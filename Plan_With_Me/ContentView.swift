import SwiftUI

struct ContentView: View {
    @State private var isCreateNewPlanPresented = false
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var backgroundColor = Color.green
    @State private var title = "New Plan"
    @State private var note = "This is a plan."
    @State private var isMenuPresented = false
    @State private var navigateToWeekPlanner = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: DailyPlanner.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyPlanner.startDate, ascending: true)],
        predicate: NSPredicate(format: "startDate >= %@ AND startDate < %@", Date() as NSDate, Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400) as NSDate)
    ) private var dailyPlans: FetchedResults<DailyPlanner>

    func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: Date())
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        self.isMenuPresented.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    
                    Text("HOME")
                        .font(.custom("Arial", size: 40))
                        .multilineTextAlignment(.center)
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 150)
                    
                    Spacer()
                }
                .frame(height: 70)
                .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                .foregroundColor(.white)
                
                if isMenuPresented {
                    VStack {
                        Button("HOME") {
                            self.isMenuPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                        
                        Button("WEEK PLANNER") {
                            self.isMenuPresented = false
                            self.navigateToWeekPlanner = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                        
                        Button("MUST-DO") {
                            self.isMenuPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                    .transition(.move(edge: .leading))
                }
                
                
                VStack(alignment: .leading) {
                    Text("Plan With Me")
                        .font(.custom("Arial", size: 40))
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.406, saturation: 0.421, brightness: 0.966))
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .padding(.top, 40.0)
                        .background(Color.white)
                    
                    Text(getCurrentDateTime())
                        .font(.custom("Arial", size: 25))
                        .italic()
                        .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                        .padding(.leading, 40)
                        .padding(.top, 20)
                    
                    HStack {
                        Text(getCurrentTime())
                            .font(.custom("Arial", size: 25))
                            .italic()
                            .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                            .padding(.leading, 40)
                        
                        Spacer()
                        
                        Button(action: {
                            self.isCreateNewPlanPresented = true
                        }) {
                            Text("+")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color(hue: 0.406, saturation: 0.421, brightness: 0.966))
                                .clipShape(Circle())
                                .padding(.trailing, 40)
                        }
                    }
                    .padding(.top, 10)
                    
                    Text("Today's Plans: ")
                        .font(.headline)
                        .padding(.top, 20)
                        .padding(.leading, 150)
                    
                    List(dailyPlans, id: \.self) { plan in
                        VStack(alignment: .leading) {
                            Text(plan.title ?? "No title")
                                .font(.subheadline)
                            Text("From \(dateFormatter.string(from: plan.startDate!)) to \(dateFormatter.string(from: plan.endDate!))")
                            Text(plan.note ?? "No note")
                                .font(.body)
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .background(
                NavigationLink(destination: WeekPlanner(), isActive: $navigateToWeekPlanner) {
                    EmptyView()
                }
            )
            .background(Color.white)
            .sheet(isPresented: $isCreateNewPlanPresented){
                CreateNewPlan(isPresented: $isCreateNewPlanPresented, startDate: Date(), endDate: Date(), backgroundColor: Color.green, title: "", note: "")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
