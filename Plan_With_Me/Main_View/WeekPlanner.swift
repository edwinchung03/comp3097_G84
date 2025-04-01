import SwiftUI

struct WeekPlanner: View {
    
    @State private var isMenuPresented = false
    @State private var isCreateNewPlanPresented = false
    @State private var isCreateNewWeekPlanPresented = false
    @State private var isTomorrowPreviewPresented = true
    @State private var selectedButton: ButtonType = .tomorrowPreview
    @State private var navigateToHome = false
    @State private var navigateToMustdo = false
    @Environment(\.managedObjectContext) private var viewContext
    
    enum ButtonType {
        case tomorrowPreview, weeklyTasks
    }
    
    @FetchRequest(
        entity: DailyPlanner.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DailyPlanner.startDate, ascending: true)],
        predicate: {
            let calendar = Calendar.current
            let startOfTomorrow = calendar.startOfDay(for: Date()).addingTimeInterval(86400)
            let startOfDayAfterTomorrow = calendar.startOfDay(for: startOfTomorrow).addingTimeInterval(86400)
            return NSPredicate(format: "startDate >= %@ AND startDate < %@", startOfTomorrow as NSDate, startOfDayAfterTomorrow as NSDate)
        }()
    ) private var dailyPlans: FetchedResults<DailyPlanner>
    
    @FetchRequest(
        entity: WeeklyPlanner.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WeeklyPlanner.title, ascending: true)]
    ) private var weeklyPlans: FetchedResults<WeeklyPlanner>

    func getTomorrowDate() -> String {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: tomorrow)
    }
    
    func getFirstAndLastDayOfNextWeek() -> (String, String){
        let today = Date()
        let calendar = Calendar.current
        
        let currentWeekDay = calendar.component(.weekday, from: today)
        let daysToNextMonday = (9 - currentWeekDay) % 7
        let firstDayofNextWeek = calendar.date(byAdding: .day, value: daysToNextMonday, to: today)!
        let lastDayOfNextWeek = calendar.date(byAdding: .day, value: 6, to: firstDayofNextWeek)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        
        let firstDateStr = formatter.string(from: firstDayofNextWeek)
        let lastDateStr = formatter.string(from: lastDayOfNextWeek)
        
        return (firstDateStr, lastDateStr)
    }
    
    func colorFromHex(_ hex: String?) -> Color{
        guard let hex = hex, hex.hasPrefix("#"), hex.count == 7 else{
            return Color.gray
        }
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.index(after: hex.startIndex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        return Color(
            red: Double((rgbValue >> 16) & 0xFF) / 255.0,
            green: Double((rgbValue >> 8) & 0xFF) / 255.0,
            blue: Double(rgbValue & 0xFF) / 255.0
        )
    }
    
    func getNextMonday() -> Date{
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysUntilMonday = (9 - weekday) % 7
        return calendar.date(byAdding: .day, value: daysUntilMonday, to: today)!
    }
    
    func getNextSunday() -> Date{
        let calendar = Calendar.current
        let nextMonday = getNextMonday()
        return calendar.date(byAdding: .day, value: 6, to: nextMonday)!
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
                    
                    Text("WEEK PLANNER")
                        .font(.custom("Arial", size: 30))
                        .multilineTextAlignment(.center)
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.leading, 60)
                    
                    Spacer()
                }
                .frame(height: 70)
                .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                .foregroundColor(.white)
                
                if isMenuPresented {
                    VStack {
                        Button("HOME") {
                            self.navigateToHome = true
                            self.isMenuPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                                        
                        Button("WEEK PLANNER") {
                            self.isMenuPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hue: 0.336, saturation: 0.33, brightness: 0.999))
                        .foregroundColor(.black)
                                        
                        Button("MUST-DO") {
                            self.navigateToMustdo = true
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
                    
                    HStack {
                        Button(action: {
                            self.selectedButton = .tomorrowPreview
                            self.isTomorrowPreviewPresented = true
                        }) {
                            Text("Tomorrow Preview")
                                .font(.custom("Arial", size: 20))
                                .foregroundColor(self.selectedButton == .tomorrowPreview ? .black : .white)
                                .frame(width: 180, height: 50)
                                .background(self.selectedButton == .tomorrowPreview ? Color.green : Color.gray)
                                .clipShape(Capsule())
                        }
                        .padding(.trailing, 10)
                        
                        Button(action: {
                            self.selectedButton = .weeklyTasks
                            self.isTomorrowPreviewPresented = false // Hide tomorrow preview
                            }) {
                                Text("Weekly Tasks")
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(self.selectedButton == .weeklyTasks ? .black : .white)
                                    .frame(width: 180, height: 50)
                                    .background(self.selectedButton == .weeklyTasks ? Color.green : Color.gray)
                                    .clipShape(Capsule())
                            }
                            .padding(.leading, 10)
                    }
                    .padding(.top, 20)
                    
                    if self.selectedButton == .tomorrowPreview {
                        HStack {
                            Text(getTomorrowDate())
                                .font(.custom("Arial", size: 25))
                                .italic()
                                .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                                .padding(.top, 20)
                                .padding(.leading, 15)
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
                                    .padding(.trailing, 50)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.top, 10)
                        
                        VStack(alignment: .leading) {
                            Text("Tomorrow's Plan: ")
                                .font(.headline)
                                .padding(.top, 20)
                                .padding(.leading, 130)
                            
                            List{
                                ForEach(dailyPlans, id: \.self) { plan in
                                    VStack(alignment: .leading){
                                        Text(plan.title ?? "No title")
                                            .font(.headline)
                                        Text("From \(dateFormatter.string(from: plan.startDate!)) to \(dateFormatter.string(from: plan.endDate!))")
                                            .font(.subheadline)
                                        Text(plan.note ?? "No note")
                                            .font(.body)
                                    }
                                    .padding()
                                    .background(colorFromHex(plan.backgroundColor))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        let plan = dailyPlans[index]
                                        viewContext.delete(plan)
                                    }
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print("Error deleting plan: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    
                    if self.selectedButton == .weeklyTasks {
                        HStack {
                            let (firstDay, lastDay) = getFirstAndLastDayOfNextWeek()
                            VStack(alignment: .leading) {
                                Text("From \(firstDay)")
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                                                
                                Text("To \(lastDay)")
                                    .font(.custom("Arial", size: 20))
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.221, brightness: 0.577))
                                }
                                .padding(.leading, 40)
                                                
                                Spacer()
                                                
                            Button(action: {
                                self.isCreateNewWeekPlanPresented = true
                            }){
                                Text("+")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color(hue: 0.406, saturation: 0.421, brightness: 0.966))
                                    .clipShape(Circle())
                                    .padding(.trailing, 40)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.top, 10)
                                                
                        VStack(alignment: .leading) {
                            Text("Next Week's Plan: ")
                                .font(.headline)
                                .padding(.top, 20)
                                .padding(.leading, 130)
                            
                            List{
                                ForEach(weeklyPlans, id: \.self) {
                                    plan in
                                    VStack(alignment: .leading){
                                        Text(plan.title ?? "No title")
                                            .font(.headline)
                                    }
                                    .padding()
                                    .background(colorFromHex(plan.backgroundColor))
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                }
                                .onDelete { indexSet in
                                    for index in indexSet {
                                        let weekplan = weeklyPlans[index]
                                        viewContext.delete(weekplan)
                                    }
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print("Error deleting weekly plan: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .background(
                    NavigationLink(destination: ContentView(), isActive: $navigateToHome) {
                        EmptyView()
                    }
                )
                .background(
                    NavigationLink(destination: Must_do(), isActive: $navigateToMustdo) {
                        EmptyView()
                    }
                )
                .background(Color.white)
                .sheet(isPresented: $isCreateNewPlanPresented){
                    CreateNewPlan(
                        isPresented: $isCreateNewPlanPresented,
                        startDate: Date(),
                        endDate: Date(),
                        backgroundColor: Color.green,
                        title: "",
                        note: "",
                        isCompleted: false)
                }
                .sheet(isPresented: $isCreateNewWeekPlanPresented){
                    CreateNewWeekPlan(
                        isPresented: $isCreateNewWeekPlanPresented,
                        startDate: self.getNextMonday(),
                        endDate: self.getNextSunday(),
                        backgroundColor: Color.green,
                        title: "")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct WeekPlanner_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()
    }
}
