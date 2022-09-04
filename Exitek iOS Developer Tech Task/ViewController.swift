//
//  ViewController.swift
//  Exitek iOS Developer Tech Task
//
//  Created by Сергей Веретенников on 04/09/2022.
//

import UIKit

class ViewController: UIViewController {

    let dataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addNewDeviceButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Add new mobile", 
            message: "Enter model and imei", 
            preferredStyle: .alert
        )
        
        alertController.addTextField()
        alertController.addTextField()
        alertController.textFields?[0].placeholder = "Device Model"
        alertController.textFields?[1].placeholder = "IMEI"
         
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let tf1 = alertController.textFields?[0], let tf2 = alertController.textFields?[1] else { return }
            
            if tf1.text == "" || tf2.text == "" {
                let errorAlert = UIAlertController(title: "Add all fields", message: "Please", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(errorAlert, animated: true)
            } else {
                do {
                    try self?.dataManager.addNewDeviceWith(name: tf1.text ?? "", imei: tf2.text ?? "") { device in
                        let successAlert = UIAlertController(title: "Device added", message: "Model - \(tf1.text ?? "")\nIMEI - \(tf2.text ?? "")", preferredStyle: .alert)
                        successAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(successAlert, animated: true)
                    }
                } catch {
                    let errorAlert = UIAlertController(title: "Device already exist", message: nil, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(errorAlert, animated: true)
                }
            }
        }
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alertController, animated: true)
    }
    @IBAction func findByIMEITapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Enter device imei", message: "Try to find", preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?[0].placeholder = "IMEI"
        
       let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
           guard let tf1 = alertController.textFields?[0] else { return }
           
           if tf1.text == "" {
               let errorAlert = UIAlertController(
                title: "Add all fields", 
                message: "Please", preferredStyle: .alert
               )
               
               errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
               self?.present(errorAlert, animated: true)
           } else {
               
               if let device = self?.dataManager.findByImei(tf1.text ?? "") {
                   let alertControllerResult = UIAlertController(
                    title: "Found device",
                    message: "Model - \(device.model ?? "")\nIMEI - \(device.imei ?? "") ", 
                    preferredStyle: .alert
                   )
                   
                   alertControllerResult.addAction(UIAlertAction(title: "Ok", style: .default))
                   self?.present(alertControllerResult, animated: true)
               } else {
                   let alertControllerResult = UIAlertController(
                    title: "No device with that IMEI", 
                    message: nil, preferredStyle:
                            .alert
                   )
                   
                   alertControllerResult.addAction(UIAlertAction(title: "Ok", style: .default))
                   self?.present(alertControllerResult, animated: true)
               }
           }
       }
       
       alertController.addAction(addAction)
       alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
       present(alertController, animated: true)
    }
    
    @IBAction func findAllTapped(_ sender: UIButton) {
        
        let foundedDevices = dataManager.getAll()
        
        var devices = "Added devices\n"
        
        foundedDevices.forEach { mobile in
            devices += "Model - \(mobile.model ?? ""); IMEI - \(mobile.imei ?? "")\n"
        }
        
        let alertController = UIAlertController(title: devices, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Enter device imei", 
            message: "Try to delete", 
            preferredStyle: .alert
        )
        
        alertController.addTextField()
        alertController.addTextField()
        alertController.textFields?[0].placeholder = "Device Model"
        alertController.textFields?[1].placeholder = "IMEI"
         
       let addAction = UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
           guard let tf1 = alertController.textFields?[0], let tf2 = alertController.textFields?[1] else { return }
           
           if tf1.text == "" || tf2.text == "" {
               let errorAlert = UIAlertController(
                title: "Add all fields",
                message: "Please", 
                preferredStyle: .alert
               )
               
               errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
               self?.present(errorAlert, animated: true)
           } else {
               
               do {
                   try self?.dataManager.deleteDeviceWith(model: tf1.text ?? "", imei: tf2.text ?? "") {
                       let successAlert = UIAlertController(title: "Deleted", message: "Success", preferredStyle: .alert)
                       successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                       self?.present(successAlert, animated: true)
                   }
               } catch {
                   let faultAlert = UIAlertController(title: "Nothing to delete", message: nil, preferredStyle: .alert)
                   faultAlert.addAction(UIAlertAction(title: "OK", style: .default))
                   self?.present(faultAlert, animated: true)
               }
           }
       }
        
        alertController.addAction(addAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alertController, animated: true)
    }
}

