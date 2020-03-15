//
//  MoviesCoreDataModel.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 3/7/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class MoviesCoreDataModel {
    
    func saveMovies(movie : Movies)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
      
            print(movie.id!)
        if getCount() >= 50 {
                    clear(objName: "Movie")
                    clear(objName: "Reviews")
                    clear(objName: "Trailers")
        
        
                }
            if !checkExistence(searchId: movie.id!,entityName: "Movie") {

            let movieToSave = Movie(context: manageContext)
            
            movieToSave.id=movie.id
            movieToSave.image = movie.image
            movieToSave.title =  movie.title
            movieToSave.rating =  movie.rating
            movieToSave.release_date =  movie.releaseDate
            movieToSave.overview=movie.overview
            movieToSave.popularity=movie.popularity
            
        }
        
        do{
                    
            try manageContext.save()
        
                    
                    
                }catch let error{
                    
                    print(error)
                }
            
    }
    
    
//    func saveMovies(movieArray : [Movies]) -> Bool {
//            var saved : Bool = false
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let manageContext = appDelegate.persistentContainer.viewContext
//        print("SAVING CALL")
//        if getCount() >= 50 {
//            clear(objName: "Movie")
//            clear(objName: "Reviews")
//            clear(objName: "Trailers")
//
//
//        }
//
//            for item in movieArray {
//                print(item.id!)
//                if !checkExistence(searchId: item.id!,entityName: "Movie") {
//
//                let movie = Movie(context: manageContext)
//
//                movie.id=item.id
//                movie.image = item.image
//                movie.title =  item.title
//                movie.rating =  item.rating
//                movie.release_date =  item.releaseDate
//                movie.overview=item.overview
//                movie.popularity=item.popularity
//
//
//            }
//
//            do{
//
//                        try manageContext.save()
//                        saved = true
//
//
//
//                    }catch let error{
//
//                        print(error)
//                    }
//                }
//        return saved;
//        }
//
    
    func checkExistence(searchId:String,entityName:String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   let manageContext = appDelegate.persistentContainer.viewContext
        var exist:Bool = false
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
           fetchRequest.predicate = NSPredicate(format: "id ==[c] %@", searchId)

       

           do {
              let results = try manageContext.fetch(fetchRequest)
            
            if results.count > 0
            {
                print("EXISTED")
                exist=true
            }
           }
           catch {
               print("error executing fetch request: \(error)")
           }

          
        
        
        
     return exist
    }
    //Fav
    func saveFavMovies(movie : Movies) -> Bool {
            var saved : Bool = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let manageContext = appDelegate.persistentContainer.viewContext
          
                print(movie.id!)
                if !checkExistence(searchId: movie.id!,entityName: "Favorite") {

                let favMovie = Favorite(context: manageContext)
                
                favMovie.id=movie.id
                favMovie.image = movie.image
                favMovie.title =  movie.title
                favMovie.rating =  movie.rating
                favMovie.release_date =  movie.releaseDate
                favMovie.overview=movie.overview
                favMovie.popularity=movie.popularity
                
            }
            
            do{
                        
                try manageContext.save()
                        saved = true
            
                        
                        
                    }catch let error{
                        
                        print(error)
                    }
                
        return saved;
        }
    
    func saveReviews(reviewsArray : [MovieReview],movieId:String) {
               let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let manageContext = appDelegate.persistentContainer.viewContext
               for item in reviewsArray {
                   print(item.id!)
                   if !checkExistence(searchId: item.id!,entityName: "Reviews") {

                    let review=Reviews(context: manageContext)
                    review.id=item.id
                    review.contnet=item.content
                    review.author=item.author
                    review.movie_id=movieId
                    
                    
               }
               
               do{
                           
                           try manageContext.save()
               
                           
                           
                       }catch let error{
                           
                           print(error)
                       }
                   }
           }
       
       
    
    func saveTrailers(trailerArray : [MovieTrailer],movieId:String) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let manageContext = appDelegate.persistentContainer.viewContext
            for item in trailerArray {
                print(item.id!)
                if !checkExistence(searchId: item.id!,entityName: "Trailers") {

                 let trailer=Trailers(context: manageContext)
                 trailer.id=item.id
                 trailer.key=item.key
                    trailer.movie_id=movieId
                 
                 
                 
            }
            
            do{
                        
                        try manageContext.save()
            
                        
                        
                    }catch let error{
                        
                        print(error)
                    }
                }
        }
    
    
    
    
    
    
    
    
    //get fav
    
    func getFavMovies() -> [Movies] {
        var favMoviesArray = [Movies]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let manageContext = appDelegate.persistentContainer.viewContext

       //let movie = Favorite(context: manageContext)
    
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                
        
        do{
        var moviesArray: [Favorite]
            moviesArray = try manageContext.fetch(fetchRequest) as! [Favorite]
                            
            for item in moviesArray {
                                
                                
        let title = (item.value(forKey: "title")! as! String)
        let image = item.value(forKey: "image")! as! String
        let rating = item.value(forKey: "rating")! as! Float
        let release_date = item.value(forKey: "release_date")! as! String
        let id=item.value(forKey: "id")! as! String
        let overview=item.value(forKey: "overview")! as! String
        let popularity = item.value(forKey: "popularity")! as! Float
                
        let currentMovie = Movies(Id: id, Title: title, Image: image, Rating: rating,ReleaseDate: release_date, Overview: overview,Popularity: popularity)
                                favMoviesArray.append(currentMovie)
                            }

                        }catch let error{


                            print(error)

                        }
        print("FAV SIZZZZZE \(favMoviesArray.count)")
        return favMoviesArray
        }
    
    
    
    //get saved movies
    func getMoviesFromCore(sortby:String) -> [Movies] {
        var query:String="id"
        if sortby == "top_rated"{
            query="rating"
             }
        
        if sortby == "popular"{
                   query="popularity"
                    }
           var savedMoviesArray = [Movies]()
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           
           let manageContext = appDelegate.persistentContainer.viewContext

          //let movie = Favorite(context: manageContext)
       
           let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
                   
   let sort = NSSortDescriptor(key: query, ascending: false)
         fetchRequest.sortDescriptors = [sort]
//           
           do{
           var moviesArray: [Movie]
               moviesArray = try manageContext.fetch(fetchRequest) as! [Movie]
                               
               for item in moviesArray {
                                   
                                   
           let title = (item.value(forKey: "title")! as! String)
           let image = item.value(forKey: "image")! as! String
           let rating = item.value(forKey: "rating")! as! Float
                print("RAATAK  \(rating) ")
           let release_date = item.value(forKey: "release_date")! as! String
           let id=item.value(forKey: "id")! as! String
           let overview=item.value(forKey: "overview")! as! String
           let popularity=item.value(forKey: "popularity")! as!Float
           let currentMovie = Movies(Id: id, Title: title, Image: image, Rating: rating,ReleaseDate: release_date, Overview: overview,Popularity: popularity)
                                   savedMoviesArray.append(currentMovie)
                               }

                           }catch let error{


                               print(error)

                           }
           print("FAV SIZZZZZE \(savedMoviesArray.count)")
           return savedMoviesArray
           }
       
    
    
    
    
    
    
    
    //deleting Delete fav item
    
    func deleteSingleFavItem(movieId:String)->Bool{
        var deleted:Bool = false
        
     let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let context = appDelegate.persistentContainer.viewContext

        // get records which match this condition
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id ==[c] %@", movieId)

        // and delete them
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
          try context.execute(deleteRequest)
            deleted=true
        } catch let error as NSError {
          print("Could not delete all data. \(error), \(error.userInfo)")
        deleted=false
        
        }
        

       
      return deleted
    }
    
    //cleare cach
    
    
    
    func clear(objName:String) {
        var count = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: objName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                count=count+1
                if count<=20{
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
                    print("Deleting countttt+++\(count)")
                }}
        } catch let error as NSError {
            print("Delele all data in \(objName) error : \(error) \(error.userInfo)")
        }

        
        
        
    }
    
    //get count func
    
    func getCount() -> Int {
        var moviesArray: [Movie]=Array()
                   let appDelegate = UIApplication.shared.delegate as! AppDelegate
                   
                   let manageContext = appDelegate.persistentContainer.viewContext
               
                   let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
                           
       
                   do{
                   
                       moviesArray = try manageContext.fetch(fetchRequest) as! [Movie]
                      }catch let error{


                          print(error)

                      }
    
        print("CCCCOOOUUUNNNTTT\(moviesArray.count)")
    return moviesArray.count

    
    }
    
    
    
    
}
