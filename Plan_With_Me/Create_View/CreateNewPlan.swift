import SwiftUI

struct CreateNewPlan: View {
    
    @Binding var isPresented: Bool
    @State var startDate: Date
    @State var endDate: Date
    @State var backgroundColor: Color
    @State var title: String
    @State var note: String
    @State var isCompleted: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: WeeklyPlanner.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WeeklyPlanner.startDate, ascending: true)]
    ) private var weeklyPlanners: FetchedResults<WeeklyPlanner>
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.title, ascending: true)]
    ) private var routines: FetchedResults<Routine>
    
    var validWeeklyPlanners: [WeeklyPlanner] {
        let currentDate = Date()
        return weeklyPlanners.filter { weeklyPlanner in
            if let start = weeklyPlanner.startDate, let end = weeklyPlanner.endDate {
                return currentDate >= start && currentDate <= end
            }
            return false
        }
    }
    
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
            
            if !validWeeklyPlanners.isEmpty {
                Menu {
                    ForEach(validWeeklyPlanners, id: \.self) { planner in
                        Button(planner.title ?? "No Title") {
                            if let hexColor = planner.backgroundColor {
                                backgroundColor = colorFromHex(hexColor)
                            }
                            title = planner.title ?? "No Title"
                        }
                    }
                } label: {
                    HStack {
                        Text("Choose Weekly Planner")
                            .padding()
                        Spacer()
                        Image(systemName: "chevron.down.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                }
                .padding(.horizontal)
            }
            
            if !routines.isEmpty {
                Menu {
                    ForEach(routines, id: \.self) { routine in
                        Button(action: {
                            if let hexColor = routine.backgroundColor {
                                backgroundColor = colorFromHex(hexColor)
                            }
                            title = routine.title ?? "No Title"
                            note = routine.frequency ?? "No frequency"
                        }) {
                            HStack {
                                Text(routine.title ?? "No Title")
                                    .font(.body)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Choose Routine")
                            .padding()
                        Spacer()
                        Image(systemName: "chevron.down.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue))
                }
                .padding(.horizontal)
            }
            
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
                    newPlan.isCompleted = false
                    
                    // Convert Color to Hex before saving
                    newPlan.backgroundColor = UIColor(backgroundColor).toHexString()
                    
                    do {
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
    
    // Helper function to convert UIColor to Hex String
    func colorFromHex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        return Color(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
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
            note: (""),
            isCompleted: false
        )
    }
}
