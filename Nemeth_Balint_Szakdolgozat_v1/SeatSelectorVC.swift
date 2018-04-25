//
//  SeatSelectorVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 03. 26..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class selection {
    
    private var _row: Int!
    private var _column: Int!
    
    var column: Int {
        
        return _column
    }
    
    var row: Int {
        
        return _row
    }
    
    init(row: Int, column: Int) {
        
        self._column = column
        self._row = row
    }
}

class SeatSelectorVC: UIViewController, ZSeatSelectorDelegate {

    @IBOutlet weak var label: UILabel!
    
    var seatsSelected = [selection]()
    var time: CustomCinemaShowingTime?
    var seatLimit: Int?
    var userData: Dictionary<String, AnyObject>?
    
    var map: String!
    let seats = ZSeatSelector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseSeats()
    }
    
    func parseSeats() {
        
        let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.movieId)!).child("showings").child((self.time?.dateId)!).child("times").child((self.time?.timeId)!)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? Dictionary<String, AnyObject>
            let seatMap = value?["seatMap"] as? String
            
            self.map = seatMap!
            
            self.seats.frame = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: 300)
            self.seats.setSeatSize(CGSize(width: 25, height: 25))
            self.seats.setAvailableImage(   UIImage(named: "A")!,
                                             andUnavailableImage:    UIImage(named: "U")!,
                                             andDisabledImage:       UIImage(named: "D")!,
                                             andSelectedImage:       UIImage(named: "S")!)
            self.seats.layout_type = "Normal"
            self.seats.setMap(self.map)
//            self.seats.seat_price           = 5.0
            self.seats.selected_seat_limit  = self.seatLimit!
            self.seats.seatSelectorDelegate = self
            self.seats.maximumZoomScale         = 5.0
            self.seats.minimumZoomScale         = 0.05
            self.view.addSubview(self.seats)
        })
    }
    
    func seatSelected(_ seat: ZSeat) {
        //print("Seat at row: \(seat.row) and column: \(seat.column)\n")
    }
    
    func getSelectedSeats(_ seats: NSMutableArray) {
        var total:Float = 0.0;
        for i in 0..<seats.count {
            let seat:ZSeat  = seats.object(at: i) as! ZSeat
            print("Seat at row: \(seat.row) and column: \(seat.column)\n")
            self.label.text = "Row: \(seat.row) Column: \(seat.column)"
            
            let seatS = selection(row: seat.row, column: seat.column)
            self.seatsSelected.append(seatS)
        }
    }
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        var column: Int = 0
        var row: Int = 1
        var indexForEmptyColumns: Int = 0
        
        var reservedSeats = [Dictionary<String, String>]()
        
        if (self.seats.selected_seats.count != self.seats.selected_seat_limit) {
            
            let alert = UIAlertController(title: "Error", message: "You didn't choose enough seats! If you change your mind, go back and modify the number of tickets!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
        
            
            for i in 0..<self.map.characters.count {


                if (map[i] == "A") || (map[i] == "U") || (map[i] == "D") {

                    column += 1
                    indexForEmptyColumns = 0
                } else if map[i] == "_" {

                    indexForEmptyColumns += 1

                } else {

                    if indexForEmptyColumns < 4 {

                        row += 1
                    }
                    column = 0
                }
                
                print(self.seats.selected_seats.count)
                
                for index in 0..<self.seats.selected_seats.count {
                    
                    if(((row == (self.seats.selected_seats[index] as AnyObject).row)) && (column == (self.seats.selected_seats[index] as AnyObject).column)) {
                        
                        print("Rita \(row) \(column)")
        
                        var chars = Array(map.characters)
                        chars[i] = "U"
                        map = String(chars)
                    }
                }
            }
            print("RITA: \(map)")
            
            if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
                let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.movieId)!).child("showings").child((self.time?.dateId)!).child("times").child((self.time?.timeId)!).child("seatMap")
                let ref2 = DataService.ds.REF_RESERVATIONS
                let ref3 = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("reservations")
                
                for index in 0..<self.seats.selected_seats.count {
                    
                    let reservedSeat = ["Seat": (String((self.seats.selected_seats[index] as AnyObject).row) + "/" + String((self.seats.selected_seats[index] as AnyObject).column))]
                    
                    reservedSeats.append(reservedSeat)
                }
                let reservationData = ["cinemaId": self.time?.cinemaId,
                                       "cityName": self.time?.cityName,
                                       "movieId": self.time?.movieId,
                                       "dateId": self.time?.dateId,
                                       "timeId": self.time?.timeId,
                                       "userId": Auth.auth().currentUser?.uid,
                                       "tickets": reservedSeats] as [String : Any]
                
                
                let uuid = UUID().uuidString
                let data = [uuid: reservationData]
                
                let userData = ["id": uuid]
                
                ref.setValue(map)
                ref2.updateChildValues(data)
                ref3.childByAutoId().updateChildValues(userData)
                
                addUserInterest(time: self.time!)
                
                seatsSelected.removeAll()
            
                performSegue(withIdentifier: "backToStartVC", sender: nil)
                
            } else {
                
                let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.movieId)!).child("showings").child((self.time?.dateId)!).child("times").child((self.time?.timeId)!).child("seatMap")
                let ref2 = DataService.ds.REF_RESERVATIONS
                
                for index in 0..<self.seats.selected_seats.count {
                    
                    let reservedSeat = ["Seat": (String((self.seats.selected_seats[index] as AnyObject).row) + "/" + String((self.seats.selected_seats[index] as AnyObject).column))]
                    
                    reservedSeats.append(reservedSeat)
                }
                
                let reservationData = ["cinemaId": self.time?.cinemaId,
                                       "cityName": self.time?.cityName,
                                       "movieId": self.time?.movieId,
                                       "dateId": self.time?.dateId,
                                       "timeId": self.time?.timeId,
                                       "userId": self.userData,
                                       "tickets": reservedSeats] as [String : Any]
                
                let uuid = UUID().uuidString
                let data = [uuid: reservationData]
                
                ref.setValue(map)
                ref2.updateChildValues(data)
                
                seatsSelected.removeAll()
                
                performSegue(withIdentifier: "backToStartVC", sender: nil)
                }

            }
        }
    
    func addUserInterest(time: CustomCinemaShowingTime) {
        
        var comma: Int = 0
        
        let movieRef = DataService.ds.REF_MOVIES.child(time.movieId)
        movieRef.observe(DataEventType.value, with: { (snapshot) in
            
            let movieObject = snapshot.value as? [String: AnyObject]
            let genre = movieObject?["genre"]?.lowercased as? String
            
            print(genre)
            for i in 0..<(genre?.characters.count)! {
                
                if genre![i] == "," {
                    comma += 1
                }
            }
            print(comma)
            if comma == 0 {
                print("BELÉPTEM")
                let genreRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("interest")
                genreRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                     for userGenre in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        if userGenre.key == genre {
                            
                            let pushRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("interest").child(userGenre.key)
                            var genreCount = userGenre.value as! Int
                            genreCount += 1
                            pushRef.setValue(genreCount)
                        }
                    }
                })
            } else {
                
                var genres = [String]()
                var delimiter = ", "
                genres = (genre?.components(separatedBy: delimiter))!
                
                for i in 0..<genres.count {
                    
                    let genreRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("interest")
                    genreRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                        
                        for userGenre in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            if userGenre.key == genres[i] {
                                
                                let pushRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("interest").child(userGenre.key)
                                var genreCount = userGenre.value as! Int
                                genreCount += 1
                                pushRef.setValue(genreCount)
                            }
                        }
                    })
                }
            }
        })
        
        
//        var absurdist: Int = 0
//        var action: Int = 0
//        var comedy: Int = 0
//        var crime: Int = 0
//        var drama: Int = 0
//        var fantasy: Int = 0
//        var historical: Int = 0
//        var horror: Int = 0
//        var magicalRealism: Int = 0
//        var mystery: Int = 0
//        var paranoid: Int = 0
//        var philosophical: Int = 0
//        var political: Int = 0
//        var romance: Int = 0
//        var saga: Int = 0
//        var satire: Int = 0
//        var scienceFiction: Int = 0
//        var sliceOfLife: Int = 0
//        var social: Int = 0
//        var speculative: Int = 0
//        var thriller: Int = 0
//        var urban: Int = 0
//        var western: Int = 0
//
//        let genreRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("interest")
//        genreRef.observe(DataEventType.value, with: { (snapshot) in
//
//            for genre in snapshot.children.allObjects as! [DataSnapshot] {
//
//                if genre.key == "absurdist" {
//                    absurdist = Int(genre.value as! String)!
//                } else if genre.key == "action" {
//                    action = Int(genre.value as! String)!
//                } else if genre.key == "comedy" {
//                    comedy = Int(genre.value as! String)!
//                } else if genre.key == "crime" {
//                    crime = Int(genre.value as! String)!
//                } else if genre.key == "drama" {
//                    drama = Int(genre.value as! String)!
//                } else if genre.key == "fantasy" {
//                    fantasy = Int(genre.value as! String)!
//                } else if genre.key == "historical" {
//                    historical = Int(genre.value as! String)!
//                } else if genre.key == "horror" {
//                    horror = Int(genre.value as! String)!
//                } else if genre.key == "magicalRealism" {
//                    magicalRealism = Int(genre.value as! String)!
//                } else if genre.key == "mystery" {
//                    mystery = Int(genre.value as! String)!
//                } else if genre.key == "paranoid" {
//                    paranoid = Int(genre.value as! String)!
//                } else if genre.key == "philosophical" {
//                    philosophical = Int(genre.value as! String)!
//                } else if genre.key == "political" {
//                    political = Int(genre.value as! String)!
//                } else if genre.key == "romance" {
//                    romance = Int(genre.value as! String)!
//                } else if genre.key == "saga" {
//                    saga = Int(genre.value as! String)!
//                } else if genre.key == "satire" {
//                    satire = Int(genre.value as! String)!
//                } else if genre.key == "scienceFiction" {
//                    scienceFiction = Int(genre.value as! String)!
//                } else if genre.key == "sliceOfLife" {
//                    sliceOfLife = Int(genre.value as! String)!
//                } else if genre.key == "social" {
//                    social = Int(genre.value as! String)!
//                } else if genre.key == "speculative" {
//                    speculative = Int(genre.value as! String)!
//                } else if genre.key == "thriller" {
//                    thriller = Int(genre.value as! String)!
//                } else if genre.key == "urban" {
//                    urban = Int(genre.value as! String)!
//                } else {
//                    western = Int(genre.value as! String)!
//                }
//            }
//
//            let ref = DataService.ds.REF_MOVIES.child(time.movieId)
//            ref.observe(DataEventType.value, with: { (snapshot) in
//
//                let movieObject = snapshot.value as? [String: AnyObject]
//                let genre = movieObject?["genre"]?.lowercased
//
//                if ((genre?.range(of: "absurdist")) != nil) {
//                    absurdist += 1
//                } else if genre?.range(of: "action") != nil {
//                    action += 1
//                }else if ((genre?.range(of: "comedy")) != nil) {
//                    comedy += 1
//                } else if ((genre?.range(of: "crime")) != nil) {
//                    crime += 1
//                } else if ((genre?.range(of: "drama")) != nil) {
//                    drama += 1
//                } else if ((genre?.range(of: "fantasy")) != nil) {
//                    fantasy += 1
//                } else if ((genre?.range(of: "historical")) != nil) {
//                    historical += 1
//                } else if ((genre?.range(of: "horror")) != nil) {
//                    horror += 1
//                } else if ((genre?.range(of: "magicalRealism")) != nil) {
//                    magicalRealism += 1
//                } else if ((genre?.range(of: "mystery")) != nil) {
//                    mystery += 1
//                } else if ((genre?.range(of: "paranoid")) != nil) {
//                    paranoid += 1
//                } else if ((genre?.range(of: "philosophical")) != nil) {
//                    philosophical += 1
//                } else if ((genre?.range(of: "political")) != nil) {
//                    political += 1
//                } else if ((genre?.range(of: "romance")) != nil) {
//                    romance += 1
//                } else if ((genre?.range(of: "saga")) != nil) {
//                    saga += 1
//                } else if ((genre?.range(of: "satire")) != nil) {
//                    satire += 1
//                } else if ((genre?.range(of: "scienceFiction")) != nil) {
//                    scienceFiction += 1
//                } else if ((genre?.range(of: "sliceOfLife")) != nil) {
//                    sliceOfLife += 1
//                } else if ((genre?.range(of: "social")) != nil) {
//                    social += 1
//                } else if ((genre?.range(of: "speculative")) != nil) {
//                    speculative += 1
//                } else if ((genre?.range(of: "thriller")) != nil) {
//                    thriller += 1
//                } else if ((genre?.range(of: "urban")) != nil) {
//                    urban += 1
//                } else {
//                    western += 1
//                }
//
//                let userData = ["absurdist": String(absurdist),
//                                        "action": String(action),
//                                        "comedy": String(comedy),
//                                        "crime": String(crime),
//                                        "drama": String(drama),
//                                        "fantasy": String(fantasy),
//                                        "historical": String(historical),
//                                        "horror": String(horror),
//                                        "magicalRealism": String(magicalRealism),
//                                        "mystery": String(mystery),
//                                        "paranoid": String(paranoid),
//                                        "philosophical": String(philosophical),
//                                        "political": String(political),
//                                        "romance": String(romance),
//                                        "saga": String(saga),
//                                        "satire": String(satire),
//                                        "scienceFiction": String(scienceFiction),
//                                        "sliceOfLife": String(sliceOfLife),
//                                        "social": String(social),
//                                        "speculative": String(speculative),
//                                        "thriller": String(thriller),
//                                        "urban": String(urban),
//                                        "western": String(western)]
//            })
//        })
    }
}
