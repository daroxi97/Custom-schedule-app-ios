//
//  BasicCalendarView.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 25/9/24.
//

import SwiftUI

struct BasicCalendarView: View {
    @State private var selectedMonthOffset = 0
    @State private var selectedDate = Date()
    @State private var isFullScreen = false
    @State private var showSheet = true
    @ObservedObject private var viewModel = BasicCalendarViewModel ()
    @State private var currentDayiD: String = ""

    
    private let daysOfTheWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let activities = [
        "Reunión con el equipo",
        "Presentación del proyecto",
        "Llamada con el cliente",
        "Cita médica",
        "Clase de yoga",
        "Cena con amigos",
        "Visita al dentista",
        "Compra de supermercado",
        "Estudio para el examen",
        "Entrenamiento en el gimnasio"
    ]
    
    var body: some View {
        
        
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                
                VStack {
                    if (!isFullScreen) {
                        headerView
                        dayLabels
                        calendarGrid
                    }
                    footerView
                }
                .padding(7)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .animation(.easeInOut, value: isFullScreen)
            }
            .task {
                await viewModel.fetchWeather()
                
            }
        }
        
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                //Arrows to change month
                monthChangeButton(action: { selectedMonthOffset -= 1 }, image: "lessthan")
                Spacer()
                //Month title text
                Text(selectedDate.monthString())
                    .font(.system(size: 28))
                    .font(.title3)
                    .bold()
                    .foregroundColor(.darkPurple)
                    .shadow(color: Color.lightPurple.opacity(0.6), radius: 4, x: 2, y: 2)
                    .kerning(8)
                Spacer()
                monthChangeButton(action: { selectedMonthOffset += 1 }, image: "greaterthan")
            }
            Text(selectedDate.yearString())
                .font(.system(size: 15))
                .font(.title3)
                .bold()
                .foregroundColor(.darkPurple)
                .shadow(color: Color.lightPurple.opacity(0.6), radius: 4, x: 2, y: 2)
                .kerning(8)
        }
    }
    
    private func monthChangeButton(action: @escaping () -> Void, image: String) -> some View {
        Button(action: {
            withAnimation {
                action()
                selectedDate = fetchSelectedMonth()
            }
        }) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 14)
                .foregroundColor(.gray)
        }
    }
    
    private var dayLabels: some View {
        //Days of the week for the grid
        HStack {
            ForEach(daysOfTheWeek, id: \.self) { day in
                Text(day)
                    .font(.system(size: 12, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .bold()
            }
        }
        .padding(.top, 15)
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
            ForEach(fetchDates()) { date in
                dateCell(for: date)
            }
        }
    }
    
    private func dateCell(for date: CalendarDate) -> some View {
        Button(action: {
            viewModel.registerActivity(id: date.getId(), activity: ActivityModel(id: date.getId(), title: "sexe",time: TimeModel(hour: 16, day: date.date.dayString(), month: date.date.monthNumberString(), year: date.date.yearString(), endHour: 19)))
            currentDayiD = date.getId()
        }) {
            
            
            ZStack {
                Circle()
                    .fill(date.day > 0 ? (date.day % 2 == 0 ? Color.darkPurple.opacity(0.7) : Color.darkPurple.opacity(0.4)) : Color.clear)
                    .shadow(color: Color.white.opacity(0.2), radius: 5, x: 5, y: 5)
                    .frame(width: 45, height: 45)
                    .buttonStyle(PlainButtonStyle()) // Para evitar el estilo predeterminado del botón
                
                Text(date.day > 0 ? String(date.day) : String(-date.day))
                    .foregroundColor(date.day > 0 ? .white : .white.opacity(0.2))
                    .font(.system(size: 13))
            }
            .frame(height: 60)
            //in case user want to full screen activities the calendar will be semi transparent
            .opacity(isFullScreen ? 0.1 : 1)
            .animation(.easeInOut, value: isFullScreen)
        }
        .buttonStyle(PlainButtonStyle()) // Para evitar el estilo predeterminado del botón
        
    }
    
    private var footerView: some View {
        VStack {
            toggleButton
            Text("TODAY")
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            activitiesScrollView
            
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(15)
        .padding(.top, 10)
        .frame(height: .infinity)
        .animation(.easeInOut, value: isFullScreen)
        .ignoresSafeArea(.all)
    }
    
    private var toggleButton: some View {
        //Button to make activities full screen or not
        Button(action: {
            isFullScreen.toggle()
        }) {
            Image(systemName: isFullScreen ? "arrow.down" : "arrow.up")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(.white)
                .padding()
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
    
    private var activitiesScrollView: some View {
        //List of activities of the day
        ScrollView {
            VStack(spacing: 30) {
                ForEach(viewModel.registeredDaysWithActivities[currentDayiD]?.activities ?? [], id: \.self) { activity in
                    ActivityCard(activity: activity.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .padding()
            
        }
        
    }
    
    struct ActivityCard: View {
        let activity: String
        
        var body: some View {
            HStack {
                Color.blue
                    .frame(width: 10, height: 30)
                    .cornerRadius(5)
                
                VStack(alignment: .leading) {
                    Text(activity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                    Text("12:00 AM -> 1:00 PM")
                        .font(.caption)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                }
            }
        }
    }
    
    // MARK: - Date Functions
    
    private func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()
        
        var daysOfMonth = currentMonth.daysOfMonth().map {
            CalendarDate(day: calendar.component(.day, from: $0), date: $0)
        }
        
        let firstDayOfWeek = calendar.component(.weekday, from: daysOfMonth.first?.date ?? Date())
        
        for _ in 0..<firstDayOfWeek - 1 {
            let lastDayOfCurrentMonth = calendar.date(byAdding: .day, value: -1, to: daysOfMonth.first!.date)
            daysOfMonth.insert(CalendarDate(day: calendar.component(.day, from: lastDayOfCurrentMonth!) * -1, date: lastDayOfCurrentMonth!), at: 0)
        }
        
        return daysOfMonth
    }
    
    private func fetchSelectedMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: selectedMonthOffset, to: Date()) ?? Date()
    }
}

struct CalendarDate: Identifiable {
    let id = UUID()
    var day: Int
    var date: Date
    func getId() -> String{
        return (String(day) + date.monthString() + date.yearString())
    }
}

extension Date {
    func monthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self).uppercased()
    }
    
    func monthNumberString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: self).uppercased()
    }
    
    func yearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
            func dayString() -> String {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd"
                return formatter.string(from: self)
            }
    
    func daysOfMonth() -> [Date] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        let startDateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        
        var endDateComponents = DateComponents(month: 1, day: -1)
        var currentDate = startDate
        var dates: [Date] = []
        let endDate = calendar.date(byAdding: endDateComponents, to: currentDate)!
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}



#Preview {
    BasicCalendarView()
}
