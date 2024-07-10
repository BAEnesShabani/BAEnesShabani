
//  Form1View.swift -> Diese View ist für die Formular I Ansicht zuständig
//  CPC Editor Prototyp
//
//  Created by Enes Shabani
//


import SwiftUI


struct Form1View: View {
    
    //Mittels @ObservedObject erhält man eine Referenz auf das Subjekt als Teil des Beobachter-Entwurfmusters
    @ObservedObject var cpcManager: CPCManager
    //Pfad der Datei; "?" ist ein Optional: Optional ist ein Typ, der entweder einen Wert enthalten kann wie z. B. einen int-Wert oder nil (Fehlen eines Wertes)
    @Binding var cpcURL: URL?
    //Hiermit wird die Anzeige bzgl. eines erfolgreichen Speicherns festgehalten
    @State private var showSaveSuccess = false
    
    var body: some View
    
    {
        VStack {
            
            //SwiftUI-Einstellungen für den Text "Form I"
            Text("Form I")
                .font(.headline)
                .padding()
                .foregroundColor(.white)
            
            //Hier wird eingestellt, dass die Ansicht eine Ansicht zum Verschieben bzw. Scrollen sein soll, da teilweise große Tabellen nötig sind und auf kleinen Geräten diese nur begrenzt anzeigen können
            ScrollView([.horizontal, .vertical])
            {
                
                VStack(alignment: .leading)
                {
                    
                    //Hier wird über die Spalten und Zeilen von form1Rows aus CPCManager durchiteriert
                    ForEach(0..<cpcManager.form1Rows.count, id: \.self)
                    
                    { rowIndex in
                        
                        HStack {
                            
                            ForEach(0..<cpcManager.form1Rows[rowIndex].count, id: \.self)
                            
                            { columnIndex in
                                
                                if rowIndex == 0 {
                                    Text(cpcManager.form1Rows[rowIndex][columnIndex])
                                        .frame(width: 150, alignment: .leading)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                    //Eine andere farbige Untermalung soll zeigen, dass diese nicht bearbeitbar sind (Spaltenüberschriften)
                                }
                                
                                else {
                                    //Hier wird es ermöglicht, dass die Inhalte bearbeitet werden können in den einzelnen "Zellen"
                                    TextField("", text: Binding(
                                        //get-Methode zum Lesen der Daten
                                        get:
                                            { cpcManager.form1Rows[rowIndex][columnIndex] },
                                        
                                        //set-Methode zum Schreiben der Daten
                                        set:
                                        
                                            { cpcManager.form1Rows[rowIndex][columnIndex] = $0 }
                                                               )
                                            )
                                    
                                    
                                    .frame(width: 150, alignment: .leading)
                                    .padding()
                                    .background(Color.white)
                                    .textFieldStyle(PlainTextFieldStyle())
                                }
                            }
                        }
                    }
                }
                
            }
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            //Button zum Speichern des Formular I
            Button(action:
                    {
                //Hier wird die Speichern-Funktion vom CPCManager aufgerufen
                cpcManager.saveCPC(from: cpcManager.form1Rows, to: "CPCForm1_edited.csv")
                
                showSaveSuccess = true
            })
            
            {
                //Visuelle Einstellungen für den Button
                Text("Save Form I")
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showSaveSuccess)
            
            {
                //Hier wird ein modaler Dialog geöffnet um den Erfolg über die Speicherung anzuzeigen
                Alert(title: Text("CPC-Form I Saved!"), message: Text("CPC-Form I changes successfully saved!"), dismissButton: .default(Text("OK")))
                
            }
        }
        //Visuelle Einstellungen
        .background(Color.purple.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
}
