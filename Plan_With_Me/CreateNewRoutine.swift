import SwiftUI

struct CreateNewRoutine: View {
    
    @Binding var isPresented: Bool
    @State var backgroundColor: Color
    @State var title: String
    @State var frequency: String
    
    var body: some View {
        VStack {
            Text("Create a New Routine")
                .font(.title)
                .padding()
            
            TextField("Title", text: $title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Frequency", text: $frequency)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    print("Plan Saved: \(title), \(backgroundColor), \(frequency)")
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

struct CreateNewRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRoutine(
            isPresented: .constant(true),
            backgroundColor: (Color.white),
            title: (""),
            frequency: ("")
        )
    }
}
