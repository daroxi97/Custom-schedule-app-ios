/*
import SwiftUI

struct AddActivityView2: View {
    @State private var activityName: String = ""
    @State private var activityDate: Date = Date()
    @State private var selectedDurationIndex: Int? = nil
    @State private var selectedColor: Color = .blue
    @State private var customColor: Color = .red
    @State private var selectedFrequency: String = "Nunca"
    @State private var comments: String = ""
    
    @State private var alarmTimeOption: String = "Antes"
    @State private var alarmType: String = "Pop-up"
    @State private var alarmMinutesBefore: Int = 10
    @State private var rainAlertEnabled: Bool = false
    
    @State private var isTagEnabled: Bool = false
    @State private var tagName: String = ""
    
    @State private var showingCustomDuration: Bool = false
    @State private var customDurationHours: Int = 0
    @State private var customDurationMinutes: Int = 0
    
    @State private var showColorPicker: Bool = false
    
    let alarmOptions = ["Antes", "Al empezar", "Al acabar"]
    let alarmTypes = ["Pop-up", "Alarma", "No avisar"]
    
    let durations: [(Int, String)] = [
        (1, "1 min"), (15, "15 min"), (30, "30 min"), (45, "45 min"), (60, "1h")
    ]
    let colors: [Color] = [.red, .green, .blue, .orange, .purple]
    let frequencies = ["Nunca", "Diario", "Semanal", "Mensual"]
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var startTimeString: String {
        return timeFormatter.string(from: activityDate)
    }
    
    var currentDurationInMinutes: Int {
        if let selectedIndex = selectedDurationIndex {
            return durations[selectedIndex].0
        } else {
            return customDurationHours * 60 + customDurationMinutes
        }
    }
    
    var maxDurationInMinutes: CGFloat {
        return max(CGFloat(durations.map { $0.0 }.max() ?? 90), CGFloat(currentDurationInMinutes))
    }
    
    var endTime: Date {
        return Calendar.current.date(byAdding: .minute, value: currentDurationInMinutes, to: activityDate) ?? activityDate
    }
    
    var endTimeString: String {
        return timeFormatter.string(from: endTime)
    }
    
    var notificationTimeString: String? {
        if alarmTimeOption == "Antes" {
            let notificationTime = Calendar.current.date(byAdding: .minute, value: -alarmMinutesBefore, to: activityDate)
            return notificationTime.map { timeFormatter.string(from: $0) }
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.purple]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                Form {
                    activityDetailsSection
                    durationSection
                    colorSelectionSection
                    frequencySection
                    notificationsSection
                    rainAlertSection
                    tagSection
                    commentsSection
                    saveButtonSection
                }
                .background(Color.black.opacity(0.6))
                .scrollContentBackground(.hidden)
                .navigationTitle("Añadir Actividad")
                .foregroundColor(.white)
            }
        }
    }
    
    var activityDetailsSection: some View {
        Section(header: Text("Detalles de la Actividad").font(.subheadline).foregroundColor(.gray)) {
            TextField("Nombre de la actividad", text: $activityName)
                .modifier(FormFieldStyle())
            
            tagSelectorSection
            
            DatePicker("Fecha", selection: $activityDate, displayedComponents: .date)
                .modifier(FormFieldStyle())
            
            DatePicker("Hora de Inicio", selection: $activityDate, displayedComponents: .hourAndMinute)
                .modifier(FormFieldStyle())
            
            HStack {
                Text("Hora de Inicio:").formLabel()
                Spacer()
                Text(startTimeString).formValue()
            }
            
            HStack {
                Text("Hora de Fin:").formLabel()
                Spacer()
                Text(endTimeString).formValue()
            }
        }
    }
    
    
    var tagSelectorSection: some View {
        VStack {
            Picker("Tag", selection: $tagName) {
                Text("Trabajo").tag("Trabajo")
                Text("Casa").tag("Casa")
                Text("Deporte").tag("Deporte")
            }
            .pickerStyle(MenuPickerStyle())
            .padding() // Agregar padding para más espacio interno
            .background(Color.gray.opacity(0.2))
            .frame(height: 40)
            .cornerRadius(5)
        }
    }

    
    
    var durationSection: some View {
        Section(header: Text("Duración").font(.headline).foregroundColor(.white)) {
            VStack {
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width
                    let totalMinutes: CGFloat = CGFloat(currentDurationInMinutes)
                    let maxMinutes: CGFloat = maxDurationInMinutes
                    let fillWidth = totalWidth * (totalMinutes / maxMinutes)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: totalWidth, height: 40)
                            .cornerRadius(20)
                        
                        Rectangle()
                            .fill(totalMinutes > 1 ? Color.purple.opacity(0.5) : Color.clear)
                            .frame(width: fillWidth, height: 40)
                            .cornerRadius(20)
                        
                        HStack(spacing: 0) {
                            ForEach(durations.indices, id: \.self) { index in
                                let duration = durations[index]
                                Button(action: {
                                    withAnimation {
                                        selectedDurationIndex = index
                                        customDurationHours = 0
                                        customDurationMinutes = 0
                                    }
                                }) {
                                    Text(duration.1)
                                        .font(.system(size: 10))
                                        .foregroundColor(selectedDurationIndex == index ? .black : (index <= selectedDurationIndex ?? -1 ? .purple : .white))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 5)
                                        .background(selectedDurationIndex == index ? Color.purple.opacity(0.7) : Color.clear)
                                        .cornerRadius(5)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Botón para duración personalizada
                            Button(action: {
                                withAnimation {
                                    showingCustomDuration.toggle()
                                    if showingCustomDuration {
                                        selectedDurationIndex = nil // Resetear selección
                                    }
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.purple)
                            }
                            .padding(.leading, 8)
                        }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                // Mostrar picker de duración personalizada al presionar el botón +
                if showingCustomDuration {
                    VStack {
                        Text("Selecciona la duración:")
                            .font(.headline)
                        
                        HStack {
                            Picker("Horas", selection: $customDurationHours) {
                                ForEach(0..<24, id: \.self) {
                                    Text("\($0)h")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100)
                            
                            Picker("Minutos", selection: $customDurationMinutes) {
                                ForEach(0..<60, id: \.self) {
                                    Text("\($0)m")
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100)
                        }
                        .padding()
                        
                        
                        
                        // Botón para guardar la duración
                        Button(action: {
                            withAnimation {
                                showingCustomDuration = false // Cerrar el selector de horas y minutos
                            }
                        }) {
                            Text("Guardar")
                                .font(.footnote)
                                .padding(8)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .padding(.top)
                    }
                }
                
                // Mostrar duración seleccionada, tanto predefinida como personalizada
                if selectedDurationIndex != nil {
                    Text("Duración: \(durations[selectedDurationIndex!].1)")
                        .font(.headline)
                        .padding(.top)
                } else if customDurationHours > 0 || customDurationMinutes > 0 {
                    Text("Duración: \(customDurationHours)h \(customDurationMinutes)m")
                        .font(.headline)
                        .padding(.top)
                }
            }
        }
    }
    
    var colorSelectionSection: some View {
        Section(header: Text("Color").font(.headline).foregroundColor(.white)) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    // Colores predefinidos con tamaños más pequeños
                    ForEach(colors, id: \.self) { color in
                        ColorCircleButton(color: color, isSelected: selectedColor == color) {
                            withAnimation { selectedColor = color }
                        }
                        .frame(width: 30, height: 30) // Círculos más pequeños
                    }
                    
                    // ColorPicker personalizado, sin envoltura
                    ColorPicker("", selection: $customColor)
                        .labelsHidden()
                        .frame(width: 30, height: 30)  // Tamaño del ColorPicker como estaba antes
                        .onChange(of: customColor) { newColor in
                            selectedColor = newColor
                        }
                }
                .padding(.vertical, 5)
                .padding(.horizontal)
            }
        }
    }
    
    var frequencySection: some View {
        Section(header: Text("Frecuencia").font(.headline).foregroundColor(.white)) {
            Picker("Frecuencia", selection: $selectedFrequency) {
                ForEach(frequencies, id: \.self) { frequency in
                    Text(frequency).tag(frequency)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
        }
    }
    
    var notificationsSection: some View {
        Section(header: Text("Notificaciones").font(.headline).foregroundColor(.white)) {
            Picker("Notificación", selection: $alarmType) {
                ForEach(alarmTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
            
            Picker("Tiempo de aviso", selection: $alarmTimeOption) {
                ForEach(alarmOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
            
            if alarmTimeOption == "Antes" {
                Stepper("Minutos Antes: \(alarmMinutesBefore)", value: $alarmMinutesBefore, in: 1...120)
                    .modifier(FormFieldStyle())
            }
        }
    }
    
    var rainAlertSection: some View {
        Section(header: Text("Alerta de Lluvia").font(.headline).foregroundColor(.white)) {
            Toggle("Notificar si va a llover", isOn: $rainAlertEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
        }
    }
    
    var tagSection: some View {
        Section(header: Text("Etiquetas").font(.headline).foregroundColor(.white)) {
            Toggle("Activar etiquetas", isOn: $isTagEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
            
            if isTagEnabled {
                TextField("Etiqueta", text: $tagName)
                    .modifier(FormFieldStyle())
            }
        }
    }
    
    var commentsSection: some View {
        Section(header: Text("Comentarios").font(.headline).foregroundColor(.white)) {
            TextEditor(text: $comments)
                .frame(height: 100)
                .modifier(FormFieldStyle())
        }
    }
    
    var saveButtonSection: some View {
        Section {
            Button(action: {
                // Lógica para guardar la actividad
            }) {
                Text("Guardar Actividad")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct ColorCircleButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}

extension Text {
    func formLabel() -> some View {
        self.font(.subheadline).foregroundColor(.gray)
    }
    
    func formValue() -> some View {
        self.font(.headline).foregroundColor(.purple)
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView2()
            .preferredColorScheme(.dark)
    }
}
*/
