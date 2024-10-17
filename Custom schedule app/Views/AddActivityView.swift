import SwiftUI

struct AddActivityView: View {
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
    @State private var finishedActivityEnabled: Bool = false

    @State private var isTagEnabled: Bool = false
    @State private var tagName: String = ""
    @State private var showSuccessMessage: Bool = false
    @State private var showingCustomDuration: Bool = false
    @State private var customDurationHours: Int = 0
    @State private var customDurationMinutes: Int = 0
    @State private var successMessageOpacity = 0.0

    @State private var showColorPicker: Bool = false
    
    @State private var showTimePicker = false  // Para controlar si se muestra el DatePicker
    @State private var selectedTime: Date = Calendar.current.date(bySettingHour: 0, minute: 1, second: 0, of: Date())!
    @State private var confirmedTime: String = "" // Para almacenar el valor confirmado
    
    let icons = ["clock", "gearshape", "heart", "star", "bell", "flame"]
    
    // Variable de estado para rastrear el icono seleccionado
    @State private var selectedIcon : String? = nil

    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case subject
        case message
    }

    let alarmOptions = ["Antes", "Al empezar", "Al acabar"]
    let alarmTypes = ["Pop-up", "Alarma", "No avisar"]
    
    let durations: [(Int, String)] = [
        (1, "1 min"), (15, "15 min"), (30, "30 min"), (45, "45 min"), (60, "1h")
    ]
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .brown]
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
        return max(CGFloat(75), CGFloat(currentDurationInMinutes))
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
                    completededActivityCheckerSection
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
            VStack {
                
                TextField("Nombre de la actividad", text: $activityName)
                    .padding(.vertical, 10) // Inner padding for text
                    .modifier(FormFieldStyle())
                
                
            }
            
            tagSelectorSection
            iconSelector
            
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
    
    var iconSelector: some View {
        
                       
                       // Picker para elegir el ícono
                       Picker(selection: $selectedIcon, label: Text("Ícono")) {
                           ForEach(icons, id: \.self) { icon in
                               HStack {
                                   Image(systemName: icon)
                                   Text(icon.capitalized)
                               }
                               .tag(icon as String?)
                           }
                       }
                       .pickerStyle(MenuPickerStyle())
                       .padding() // Agregar padding para más espacio interno
                       .background(Color.gray.opacity(0.2))
                       .frame(height: 55)
                       .cornerRadius(5)
        
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
            .frame(height: 55)
            .cornerRadius(5)
        }
    }

    
    
    var durationSection: some View {
        Section(header: Text("Duración").font(.headline).foregroundColor(.white)) {
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width
                    let totalMinutes: CGFloat = CGFloat(currentDurationInMinutes)
                    let maxMinutes: CGFloat = maxDurationInMinutes
                    let fillWidth = totalWidth * (totalMinutes / maxMinutes)
                    
                   
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: totalWidth, height: 40)
                            .cornerRadius(10)
                        
                        Rectangle()
                            .fill(totalMinutes > 1 ? Color.purple.opacity(0.5) : Color.clear)
                            .frame(width: fillWidth, height: 40)
                            .cornerRadius(20)
                        
                        HStack() {
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
                                        .padding(.vertical, 13)

                                        .background(selectedDurationIndex == index ? Color.purple : Color.clear)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
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
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.purple)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            
                         
                    }
                }
                .frame(height: 40)
                .padding(.horizontal)
                
                // Mostrar picker de duración personalizada al presionar el botón +
                if showingCustomDuration {
                    VStack {
                        DatePicker("Seleccione la hora", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(WheelDatePickerStyle()) // Estilo de rueda para seleccionar horas y minutos
                            .labelsHidden()  // Ocultar la etiqueta "Seleccione la hora"
                            .padding()
                        
                        // Mostrar horas y minutos seleccionados con sus respectivas etiquetas
                        HStack {
                            Text("\(Calendar.current.component(.hour, from: selectedTime)) horas")
                                .font(.headline)
                            Text("\(Calendar.current.component(.minute, from: selectedTime)) minutos")
                                .font(.headline)
                        }
                        
                        // Botón para confirmar la hora seleccionada
                        Button(action: {
                            // Acción de confirmar la selección de tiempo
                            let hour = Calendar.current.component(.hour, from: selectedTime)
                            let minute = Calendar.current.component(.minute, from: selectedTime)
                            customDurationHours = hour
                            customDurationMinutes = minute
                            confirmedTime = "\(hour) horas y \(minute) minutos"
                            showingCustomDuration = false  // Ocultar el selector al confirmar
                        }) {
                            Text("Confirmar")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                                .padding(.top, 10)
                        }
                        .buttonStyle(BorderlessButtonStyle())

                    
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
            
            if (alarmType != "No avisar")
            {
            Picker("Tiempo de aviso", selection: $alarmTimeOption) {
                ForEach(alarmOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
            
                if alarmTimeOption == "Antes" {
                    HStack {
                        // Incluimos el Stepper para ajustar los minutos
                        Stepper("Minutos antes:  \(alarmMinutesBefore)", value: $alarmMinutesBefore, in: 1...120)
                            .modifier(FormFieldStyle())
                        
                        Spacer()  // Para empujar el botón hacia la derecha
                        
                        Button(action: {
                            // Mostrar el selector de tiempo cuando se pulsa el botón
                            showTimePicker.toggle()
                        }) {
                            Image(systemName: "clock.fill")
                                .resizable()  // Permite cambiar el tamaño del icono
                                .frame(width: 16, height: 16)  // Ajusta el tamaño del icono (puedes cambiar estos valores)
                                .foregroundColor(.white)
                                .padding(6)  // Reduce el padding para que el botón sea más pequeño
                                .background(Color.purple)
                                .cornerRadius(5)  // Ajusta el radio de las esquinas para que el botón sea más pequeño
                        }
                    }
                    
                    // Mostrar el DatePicker si el botón ha sido presionado
                    if showTimePicker {
                        VStack {
                            DatePicker("Seleccione la hora", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                                .datePickerStyle(WheelDatePickerStyle()) // Estilo de rueda para seleccionar horas y minutos
                                .labelsHidden()  // Ocultar la etiqueta "Seleccione la hora"
                                .padding()
                            
                            // Mostrar horas y minutos seleccionados con sus respectivas etiquetas
                            HStack {
                                Text("\(Calendar.current.component(.hour, from: selectedTime)) horas")
                                    .font(.headline)
                                Text("\(Calendar.current.component(.minute, from: selectedTime)) minutos")
                                    .font(.headline)
                            }
                            
                            // Botón para confirmar la hora seleccionada
                            Button(action: {
                                // Acción de confirmar la selección de tiempo
                                let hour = Calendar.current.component(.hour, from: selectedTime)
                                let minute = Calendar.current.component(.minute, from: selectedTime)
                                alarmMinutesBefore = hour * 60 + minute
                                confirmedTime = "\(hour) horas y \(minute) minutos"
                                showTimePicker = false  // Ocultar el selector al confirmar
                            }) {
                                Text("Confirmar")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(8)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    
                }
            }
        }
    }


    
    var rainAlertSection: some View {
        Section(header: Text("Alerta de Lluvia").font(.headline).foregroundColor(.white)) {
            Toggle("Notificar si va a llover", isOn: $rainAlertEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
        }
    }
    
    var completededActivityCheckerSection: some View {
        Section(header: Text("Finalización actividad").font(.headline).foregroundColor(.white)) {
            Toggle("Registrar manualmente finalización de la actividad", isOn: $finishedActivityEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
        }
    }
    

    var tagSection: some View {
        
        Section(header: Text("Guardar ajustes de actividad").font(.headline).foregroundColor(.white)) {
            Toggle("Registrar Tag", isOn: $isTagEnabled)
                .toggleStyle(SwitchToggleStyle(tint: Color.purple))
            
            if isTagEnabled {
                VStack {
                    TextField("Nombre del Tag", text: $tagName)
                        .modifier(FormFieldStyle())
                    
                    Button(action: {
                        // Lógica para guardar el tag
                        if !tagName.isEmpty {
                            tagName = ""

                            showSuccessMessage = true
                            successMessageOpacity = 1.0  // Mostrar el mensaje con opacidad completa

                            // Resetea el tagName después de guardarlo
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                
                                // Iniciar animación de desvanecimiento
                                withAnimation {
                                    successMessageOpacity = 0.0  // Desvanecer el mensaje
                                }

                                // Ocultar el mensaje completamente después de la animación
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showSuccessMessage = false
                                }
                            }
                        }
                    }) {
                        ZStack{
                            Text("Confirmar Tag")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(8)
                                .padding(.top, 8)
                            
                            if showSuccessMessage {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Tag guardado correctamente")
                                        .foregroundColor(.green)
                                }
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(8)
                                .padding(.top, 10)
                                .opacity(successMessageOpacity)  // Controlar la opacidad del mensaje
                                .animation(.easeInOut(duration: 1.0), value: successMessageOpacity)  // Animación de desvanecimiento
                            }
                            
                        }
                    }
                    
                    // Mostrar mensaje de éxito
                
                }
            }
        }
    }


    private var confirmationText: some View {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Tag guardado correctamente")
                    .foregroundColor(.green)
            }
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(8)
            .padding(.top, 10)
            .opacity(successMessageOpacity)  // Controlar la opacidad del mensaje
            .animation(.easeInOut(duration: 1.0), value: successMessageOpacity)  // Animación de desvanecimiento
        
        
    }


    
    var commentsSection: some View {
        VStack{
            Section(header: Text("Comentarios").font(.headline).foregroundColor(.white)) {
                TextEditor(text: $comments)
                    .frame(height: 100)
                    .modifier(FormFieldStyle())
            }
        }
        .toolbar {
             ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(focusField == .subject ? "Next" : "Done") {
                   if focusField == .subject {
                      focusField = .message
                   } else {
                      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                      focusField = nil
                   }
                }
             }
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
        AddActivityView()
            .preferredColorScheme(.dark)
    }
}
