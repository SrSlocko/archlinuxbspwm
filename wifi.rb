
#!/usr/bin/env ruby

# Obtener la lista de redes Wi-Fi disponibles
wifi_info = `nmcli dev wifi list`.split("\n")[1..-1].map(&:split)
num_redes = wifi_info.size

# Mostrar la lista de redes Wi-Fi con números
if num_redes > 0
  wifi_info.each_with_index do |info, index|
    puts "#{index} #{info[1..-1].join(' ')}"
  end

  # Solicitar al usuario que ingrese el número de la red Wi-Fi
  print "Ingresa el número de la red Wi-Fi a la que deseas conectarte: "
  numero_red = gets.chomp.to_i

  # Verificar si el número de red es válido
  if numero_red >= 0 && numero_red < num_redes
    ssid = wifi_info[numero_red][1]
    # Solicitar al usuario que ingrese la contraseña
    print "Ingresa la contraseña de la red Wi-Fi '#{ssid}': "
    password = gets.chomp

    # Conectar a la red Wi-Fi
    connection_result = `nmcli device wifi connect "#{ssid}" password "#{password}" 2>&1`

    if $?.success?
      puts "Conexión a '#{ssid}' exitosa."
    else
      puts "No se pudo conectar a '#{ssid}'. Verifica la contraseña."
      puts connection_result
    end
  else
    puts "Número de red no válido. Ejecuta el script nuevamente y selecciona un número de red válido."
  end
else
  puts "No hay redes Wi-Fi disponibles. :("
end

# Mostrar la imagen ASCII desde el archivo "nekoarc.txt"
if File.exist?("nekoarc.txt")
  puts File.read("nekoarc.txt")
end
