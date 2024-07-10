//
//  ContentView.swift -> Hauptansicht des Prototyps
//  CPC Editor Prototyp
//
//  Created by Enes Shabani
//

import SwiftUI


struct ContentView: View {
    
    //Fehlermeldung-Eigenschaft
    @State var showErrorAlert = false
    //Hält den Status vom Dateiauswahl-Dialogfenster; @State bedeutet dabei, das hier der Zustand einer Ansicht                                                        bzw. View gespeichert und verwaltet wird
    @State private var showCPCLoader = false
    //Hält den Pfad der CPC
    @State private var cpcURL: URL?
    //Objekt vom Typ CPCManager
    @StateObject private var cpcManager = CPCManager()
    
    
    
    var body: some View {
        
        //NavigationView ist eine Containeransicht mit gestapelten Views
        NavigationView {
            
            VStack(spacing: 20) {
                
                Spacer()
                
                //Image erlaubt das Setzen eines Bildes, hier das Siemens Energy Logo mit weißer Schrift
                //Funktionen von SwiftUI zwecks Größe, Positionierung etc.
                Image(.seLogoWhiteRGB)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(.top, 50)
                
                //Unterhalb des Logos kommt der Name des Prototyps bzw. der App inkl. Eigenschaften vgl. zum Logo
                Text("CPC Editor")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
               
                
                //Wenn kein CPC-Pfad bzw. Datei-Pfad angegeben ist, so wird folgender Code ausgeführt
                
                if cpcURL == nil {
                    
                    
                    //Nach Tippen auf den Button mit dem Titel "Upload CPC", wird der Dateiauswahl-Dialog ausgeführt
                    Button(action: {  showCPCLoader = true }
                        
                    ) {
                        
                        //Visuelle Eigenschaften vom Button
                        Text("Upload CPC")
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    
                    
                    //Hier wird der Dateiauswahl-Dialog geöffnet
                    .fileImporter(isPresented: $showCPCLoader, allowedContentTypes: [.commaSeparatedText], allowsMultipleSelection: false)
                    
                    {
                        
                        result in
                        
                        switch result {
                            
                        case .success(let urls):
                            if let url = urls.first {
                                cpcURL = url
                                
                                do {
                                    
                                    try cpcManager.loadCPC(from: url)
                                    
                                    
                                }
                                
                                catch {
                                    
                                    showErrorAlert = true
                                    
                                }
                                
                                
                            }
                        
                        case .failure(let error):
                            showErrorAlert = true
                            print("ERROR! Message: (error.localizedDescription")
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                else {
                    
                    
                    /*Ist bereits eine CPC bzw. Datei hochgeladen worden, so erlaubt NavigationLink, dass man zur Ansicht gelangt, wo der User weitere Schritte
                     unternehmen kann*/
                    
                    NavigationLink(destination: Form1View(cpcManager: cpcManager, cpcURL: $cpcURL)){
                        
                        //Zeigt den Button an um zur Form1View bzw. Formular I Ansicht zu gelangen
                        Text("Show Form I")
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        }
                    
                    NavigationLink(destination: Form2View(cpcManager: cpcManager, cpcURL: $cpcURL)){
                        
                        //Zeigt den Button an um zur Form2View bzw. Formular II Ansicht zu gelangen
                        Text("Show Form II")
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                        
                        }
                        
                    
                    //Ein weiterer Button soll es ermöglichen eine neue CPC bzw. Datei hochzuladen
                    
                    Button(action: {
                        
                        //Alle vorliegenden Daten sollen gelöscht werden
                        cpcManager.clearData()
                        //Der Pfad der @State-Eigenschaft "cpcURL" wird zurückgesetzt auf nil
                        cpcURL = nil
                        
                    }){
                        
                        //Eigenschaften des Button
                        Text("Upload new CPC")
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                }
                Spacer()
                
                //Eigenschaften des Textes für das Urheberrecht
                Text("© Siemens Energy")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
            }
            
            //Einstellung zur Nutzung des gesamten verfügbaren Displayinhalts
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //Einstellung der Hintergrundfarbe sowie die Einstellung, dass dieser über den gesamten Hintergrund gelten soll
            .background(Color.purple.edgesIgnoringSafeArea(.all))
            
            //Modaler-Dialog im Fehlerfall, wenn die CPC nicht hochgeladen werden konnte
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("ERROR!"), message: Text("CPC Upload was not able!"), dismissButton: .default(Text("OK"))
                )}
            
            
            
        }
    }
    
}
