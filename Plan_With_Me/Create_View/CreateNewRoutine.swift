import SwiftUI

struct CreateNewRoutine: View {
    
    @Binding var isPresented: Bool
    @State var backgroundColor: Color
    @State var title: String
    @State var selectedFrequency: String = "Every day"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let frequencyOptions = [
        "Every day", "Every two days", "Twice a week", "Three times a week",
        "Every week", "Every two weeks", "Every month", "Every two months"
    ]
    
    var body: some View {
        VStack {
            Text("Create a New Routine")
                .font(.title)
                .padding()
            
            TextField("Title", text: $title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Picker("Frequency", selection: $selectedFrequency) {
                ForEach(frequencyOptions, id: \..self) {
                    option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
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
                    let newRoutine = Routine(context: viewContext)
                    newRoutine.title = title
                    newRoutine.frequency = selectedFrequency
                    newRoutine.backgroundColor = UIColor(backgroundColor).toHexString()
                    
                    do{
                        try viewContext.save()
                        print("Routine Saved: \(title), \(backgroundColor), \(selectedFrequency)")
                        self.isPresented = false
                    } catch{
                        print("Failed to save routine: \(error.localizedDescription)")
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

struct CreateNewRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRoutine(
            isPresented: .constant(true),
            backgroundColor: (Color.white),
            title: ("")
        )
    }
}
