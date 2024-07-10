
// CPCManager.swift -> "Herz" des Prototyps. Die Klasse CPCManager verwaltet das Laden, Speichern sowie die spätere Aufteilung auf beide Formulare
// CPC Editor Prototyp
//
// Created by Enes Shabani
//

//Standard-Bibliothek
import Foundation
//Package um u. a. Datein im CSV-Format lesen zu können uvm. nach [DEHASE21]
import CodableCSV



class CPCManager:ObservableObject {
    
    @Published var rows: [[String]] = [] //Diese Variable enthält alle Zeilen der hochgeladenen CPC
    @Published var columns: [String] = [] //Diese Variable enthält alle Spalten der hochgeladenen CPC
    @Published var form1Rows: [[String]] = [] //Hier werden die ersten vier Spalten der genutzten CPC-Struktur gespeichert
    @Published var form2Rows: [[String]] = [] //Hier werden die letzten vier Spalten der genutzten CPC-Struktur gespeichert
    
    
    
    //Löscht alle gespeicherten Daten
    func clearData() {
        rows = []
        columns = []
        form1Rows = []
        form2Rows = []
        
        print("Data flushed!")
    }
    
    
    
    func loadCPC(from url : URL) {
        
        
        //Das Ausführen der clearData()-Funktion soll sicherstellen, dass der Speicher der Varibalen form1Rows sowie form2Rows "geleert" wird
        
        clearData()
        
        do {
            
            //Der Inhalt der Datei soll als UTF-8 codierte Zeichenkette ausgelesen werden (da oft die digitalen CPC im Format UTF-8 abgespeichert werden!)
            //!!! Implementierung basiert auf [DEHASE21] !!!
            
            let data = try String(contentsOf: url, encoding: .utf8)
                
                let decoder = CSVDecoder {
                    $0.headerStrategy = .none
                    $0.delimiters.field = ";" //Bei CSV-Dateien wird das ";" als Trennzeichen für Spalten & Reihen verwendet
                    
                }
                
                //Dekodiert die CSV-Daten in ein zweidimensionales Array von Zeichenfolgen
                let cpcRows = try decoder.decode([[String]].self, from: data)
            
           if let headerRow = cpcRows.first {
                
                self.columns = headerRow
                self.rows = Array(cpcRows.dropFirst())
                
                
            }
                
                
                //Teilt die Daten in form1Rows und form2Rows auf
                self.splitData()
                print("CPC loaded: \(cpcRows)")
                
            } catch{
                    
                    print("ERROR occured while loading CPC file: \(error)")
                    
                    
                }
                
            }
        
        
        
       
        
        func saveCPC(from rows: [[String]], to filename: String) {
            
            do {
                //Aus den Zeilen wird jetzt die Zeichenfolge gebildet
                var csvString = ""
                csvString = csvString + columns.joined(separator: ";") + "\n"
                for row in rows
                {
                    let line = row.joined(separator: ";")
                    csvString += line + "\n"
                }
                
                //Pfadermittlung und Unterordnererstellung
                let fileManager = FileManager.default
                
                if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
                {
                    let customFolderURL = documentsURL.appendingPathComponent("CPC Forms (edited!)", isDirectory: true)
                    
                    //Hier wird der Ordner im Falle einer Nichtexistenz erstellt
                    if !fileManager.fileExists(atPath: customFolderURL.path) {
                        try fileManager.createDirectory(at: customFolderURL, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    let fileURL = customFolderURL.appendingPathComponent(filename)
                    
                    //Schreibt den Inahlt in eine Datei
                    try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                    print("CPC file saved at: \(fileURL)")
                }
            }
            catch
            {
                print("ERROR occured while trying to save CPC file!: \(error)")
            }
        }
        
         
    /*Die splitData()-Funktion teil die CPC nach Spalten und Reihen auf*/
    func splitData()
        
        {
            form1Rows = []
            form2Rows = []
            
            form1Rows.append(Array(columns.prefix(4)))
            form2Rows.append(Array(columns.suffix(4)))
            
            for row in rows
            {
                
                let form1Row = Array(row.prefix(4))
                form1Rows.append(form1Row)
                
                let form2Row = Array(row.suffix(4))
                form2Rows.append(form2Row)
              
            }
            
            print("Data has been split in Form I: \(form1Rows) and Form II: \(form2Rows)")
        }
        
        
        
    }
    
    
    


