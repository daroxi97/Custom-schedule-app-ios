//
//  BasicCalendarView.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 25/9/24.
//

import SwiftUI

struct BasicCalendarView: View {
    @State var selectedMonth = 0
    @State var selectedDate = Date ()
    @State private var isFullScreen = false
    @State var showSheet = true

    let daysOfTheWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let activities = [
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
    let height = stride(from: 0.5, through: 0.9, by: 0.1).map{ PresentationDetent.fraction($0)}

    var body: some View {
        
        ZStack {
            Color.black// Example background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            selectedMonth += 1
                            selectedDate = fetchSelectedMonth()
                        }
                    } label: {
                        Image (systemName: "lessthan")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 8, height: 14)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text (selectedDate.monthString())
                        .font(.system(size: 28))
                        .font(.title3)
                        .bold()
                        .foregroundColor(.darkPurple)
                        .shadow(color: Color.lightPurple.opacity(0.6), radius: 4, x: 2, y: 2)
                        .kerning(8)
                    
                    
                    
                    
                    Spacer()
                    Button {
                        withAnimation {
                            selectedMonth += 1
                            selectedDate = fetchSelectedMonth()
                        }
                    } label: {
                        Image (systemName: "greaterthan")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 8, height: 14)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                }
                Text (selectedDate.yearString())
                    .font(.headline)
                    .bold()
                    .foregroundColor(.darkPurple)
                    .shadow(color: Color.lightPurple.opacity(0.5), radius: 4, x: 2, y: 2)
                    .kerning(8)
                
                HStack {
                    ForEach (daysOfTheWeek, id: \.self) { dayOfTheWeek in
                        Text (dayOfTheWeek)
                            .font(.system(size: 12, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                            .bold()
                        
                        
                    }
                }
                .padding(.top, 15)
                LazyVGrid (columns: Array (repeating: GridItem(.flexible()), count: 7), spacing: 0){
                    ForEach (fetchDates()) { date in
                        ZStack {
                            if date.day > 0 {
                                if date.day % 2 == 0{
                                    Circle().fill(.darkPurple.opacity(0.7))
                                        .shadow(color: Color.white.opacity(0.2), radius: 5, x: 5, y: 5)
                                        .frame(width: 45, height: 45)
                                    
                                    
                                }
                                else {
                                    Circle().fill(.darkPurple.opacity(0.4))
                                        .shadow(color: Color.white.opacity(0.2), radius: 5, x: 5, y: 5)
                                        .frame(width: 45, height: 45)
                                    
                                }
                                Text (String(date.day)).foregroundColor(.white)
                                    .font(.system(size: 13))
                                
                            }
                            else {
                                Text (String(date.day * -1)).foregroundColor(.white.opacity(0.2))
                                    .font(.system(size: 13))
                                
                            }
                        }
                        .frame(height: 60)
                        .opacity(isFullScreen ? 0.1: 1)
                        .animation(.easeInOut, value: isFullScreen) // Animación de opacidad
                        
                    }
                    
                }
                Spacer()
                
                
                VStack {
                    Button(action: {
                        isFullScreen.toggle()
                        showSheet.toggle()// Cambiar el estado al presionar el botón
                    }) {
                        if (!isFullScreen) {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 18, height: 18) // Ajusta el tamaño de la flecha
                                .foregroundColor(.white) // Color del ícono
                                .padding()
                                .clipShape(Circle()) // Forma circular
                                .shadow(radius: 5) // Sombra opcional
                        }
                        else {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 18, height: 18) // Ajusta el tamaño de la flecha
                                .foregroundColor(.white) // Color del ícono
                                .padding()
                                .clipShape(Circle()) // Forma circular
                                .shadow(radius: 5) //
                        }
                    }
                    Text ("TODAY")
                    
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                    // ScrollView para la lista de actividades
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(activities, id: \.self) { activity in
                                ActivityCard(activity: activity)
                                
                            }
                        }
                    }
                    .padding()
                    
                }
                
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
                
                .padding(.top, 10)
                .frame(height: isFullScreen ? UIScreen.main.bounds.height * 1.1 : .infinity)
                .frame(height: .infinity)
                .animation(.easeInOut, value: isFullScreen)
                .ignoresSafeArea(.all)
                
                
                
                
            }
            .padding(7)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .animation(.easeInOut, value: isFullScreen)
            
            Spacer()
            
            
        }.sheet(isPresented: $showSheet) {
            ZStack {
                VStack {
                    Button(action: {
                        isFullScreen.toggle()
                        showSheet.toggle()// Cambiar el estado al presionar el botón
                    }) {
                        if (!isFullScreen) {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 18, height: 18) // Ajusta el tamaño de la flecha
                                .foregroundColor(.white) // Color del ícono
                                .padding()
                                .clipShape(Circle()) // Forma circular
                                .shadow(radius: 5) // Sombra opcional
                        }
                        else {
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 18, height: 18) // Ajusta el tamaño de la flecha
                                .foregroundColor(.white) // Color del ícono
                                .padding()
                                .clipShape(Circle()) // Forma circular
                                .shadow(radius: 5) //
                        }
                    }
                    Text ("TODAY")
                    
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                    // ScrollView para la lista de actividades
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(activities, id: \.self) { activity in
                                ActivityCard(activity: activity)
                                
                            }
                        }
                    }
                    .presentationContentInteraction(.scrolls)

                    .padding()
                    
                }
                
                .cornerRadius(15)
                
                .padding(.top, 10)
                .frame(height: isFullScreen ? UIScreen.main.bounds.height * 1.1 : .infinity)
                .frame(height: .infinity)
                .animation(.easeInOut, value: isFullScreen)
                .ignoresSafeArea(.all)
            }
            .presentationDetents(Set (height))
            .background(Color.black.opacity(0.95))

        }


    }
    
    
    func fetchDates () -> [CalendarDate] {
        let calendar = Calendar.current
        let currentMonth = fetchSelectedMonth()
        
        var daysOfMonth = currentMonth.daysOfMonth().map({ CalendarDate(day: calendar.component(.day, from: $0), date: $0) })
        
        let firstDayOfWeek = calendar.component(.weekday, from: daysOfMonth.first?.date ?? Date())
        
        
        
        for _ in 0..<firstDayOfWeek - 1 {
            
            let lastDayOfCurrentMonth = calendar.date(byAdding: .day, value: -1, to: daysOfMonth.first!.date)
            
            daysOfMonth.insert (CalendarDate (day: calendar.component(.day, from: lastDayOfCurrentMonth!) * -1, date: lastDayOfCurrentMonth!), at: 0)
            
            
            
        }
        
        return daysOfMonth
        
        
    }
    
    func fetchSelectedMonth () -> Date{
        let calendar =  Calendar.current
        let month = calendar.date (byAdding: .month, value: selectedMonth, to: Date())
        return month!
        
    }
}
struct CalendarDate : Identifiable {
    let id = UUID()
    var day: Int
    var date: Date
}

extension Date {
    
    func monthAndYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }
    
    func monthString () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self).uppercased()
    }
    
    func yearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }
    
    func daysOfMonth () -> [Date]{
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        var startDateComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
        let startDate = calendar.date(from: startDateComponents)!
        
        var EndDateComponents = DateComponents(month: 1, day: -1)
        var currentDate = startDate
        var dates : [Date] = []
        let endtDate = calendar.date(byAdding: EndDateComponents, to: currentDate)!
        while (currentDate <= endtDate){
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
        
    }
}
struct ActivityCard: View {
    let activity: String
    
    var body: some View {
        HStack {
            // Elemento decorativo a la izquierda
            Color.blue
                .frame(width: 10, height: 30) // Elemento decorativo
                .cornerRadius(5)
            
            
            VStack {
                Text(activity)
                    .font(.headline) // Ajuste de fuente
                    .foregroundColor(.white)
                
                    .frame(maxWidth: .infinity, alignment: .leading) // Alineación a la izquierda
                    .shadow(radius: 3)
                
                Text("12:00 AM -> 1:00 PM")
                    .font(.caption) // Ajuste de fuente
                    .foregroundColor(.white)
                
                    .frame(maxWidth: .infinity, alignment: .leading) // Alineación a la izquierda
                    .shadow(radius: 3)
                
            }
            
        }
        
        
    }
}


#Preview {
    BasicCalendarView()
}



struct sexe: View {
    let activities = [
        "Reunión con el equipo",
        "Presentación del proyecto",
        "Llamada con el cliente",
        "Cita médica",
        "Clase de yoga",
        "Cena con amigos",
        "Visita al dentista",
        "Compra de supermercado",
        "Estudio para el examen",
        "Entrenamiento en el gimnasio"]
    var body: some View {
        
        VStack {
            Button(action: {
            }) {
                Text("Cerrar")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Text ("TODAY")
            
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            // ScrollView para la lista de actividades
            ScrollView {
                VStack(spacing: 30) {
                    ForEach(activities, id: \.self) { activity in
                        ActivityCard(activity: activity)
                        
                    }
                }
            }
            .padding(.top, 15)
            
            .frame(maxHeight: 400) // Limitar la altura del ScrollView
            
            
        }
        .background(Color.black.opacity(0.05))
        .frame( maxWidth: .infinity, maxHeight: .infinity)
    }
}
