import SwiftUI

struct CreateNewWeekPlan: View {
    
    @Binding var isPresented: Bool
    @State var startDate: Date
    @State var endDate: Date
    @State var backgroundColor: Color
    @State var title: String
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Text("Create a New Week Plan")
                .font(.title)
                .padding()
            
            TextField("Title", text: $title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .padding()
                .padding(.horizontal)
            
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                .padding()
                .padding(.horizontal)
            
            ColorPicker("Background Color", selection: $backgroundColor)
                .padding()
                .padding(.horizontal)
            
            
            HStack {
                Button("Cancel") {
                    self.isPresented = false
                }
                .padding()
                .foregroundColor(.red)
                
                Spacer()
                
                Button("Save") {
                    let newWeekPlan = WeeklyPlanner(context: viewContext)
                    newWeekPlan.title = title
                    newWeekPlan.startDate = startDate
                    newWeekPlan.endDate = endDate
                    newWeekPlan.backgroundColor = UIColor(backgroundColor).toHexString()
                    
                    do{
                        try viewContext.save()
                        print("Week Plan saved: \(title), \(startDate), \(endDate), \(backgroundColor)")
                        self.isPresented = false
                    } catch{
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

struct CreateNewWeekPlanView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewWeekPlan(
            isPresented: .constant(true),
            startDate: (Date()),
            endDate: (Date()),
            backgroundColor: (Color.white),
            title: ("")
        )
    }
}
