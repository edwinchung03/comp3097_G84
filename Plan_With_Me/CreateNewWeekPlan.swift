import SwiftUI

struct CreateNewWeekPlan: View {
    
    @Binding var isPresented: Bool
    @State var startDate: Date
    @State var endDate: Date
    @State var backgroundColor: Color
    @State var title: String
    
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
                    print("Plan Saved: \(title), \(startDate), \(endDate), \(backgroundColor)")
                    self.isPresented = false
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
