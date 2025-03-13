//
//  CreateNewPlan.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-02-25.
//

// CreatePlanView.swift

import SwiftUI

struct CreateNewPlan: View {
    
    @Binding var isPresented: Bool
    @State var startDate: Date
    @State var endDate: Date
    @State var backgroundColor: Color
    @State var title: String
    @State var note: String
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Text("Create a New Plan")
                .font(.title)
                .padding()
            
            TextField("Title", text: $title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            DatePicker("Start", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                .padding()
                .padding(.horizontal)
            
            DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                .padding()
                .padding(.horizontal)
            
            ColorPicker("Background Color", selection: $backgroundColor)
                .padding()
                .padding(.horizontal)
            
            TextField("Add Note", text: $note)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            HStack {
                Button("Cancel") {
                    self.isPresented = false
                }
                .padding()
                .foregroundColor(.red)
                
                Spacer()
                
                Button("Save") {
                    let newPlan = DailyPlanner(context: viewContext)
                    newPlan.title = title
                    newPlan.startDate = startDate
                    newPlan.endDate = endDate
                    newPlan.note = note
                    
                    newPlan.backgroundColor = UIColor(backgroundColor).toHexString()
                    
                    do{
                        try viewContext.save()
                        print("Plan Saved: \(title), \(startDate), \(endDate), \(backgroundColor), \(note)")
                        self.isPresented = false
                    } catch {
                        print("Failed to save plan: \(error.localizedDescription)")
                    }
                }
                .padding()
                .foregroundColor(.green)
            }
            
            .padding(.horizontal)
        }
        .padding()
    }
}

struct CreatePlanView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPlan(
            isPresented: .constant(true),
            startDate: (Date()),
            endDate: (Date()),
            backgroundColor: (Color.white),
            title: (""),
            note: ("")
        )
    }
}
