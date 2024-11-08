//
//  viewControllerEditarPerfil.swift
//  JSONRESTful
//
//  Created by mauro on 11/8/24.
//

import UIKit

class viewControllerEditarPerfil: UIViewController {
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    var usuarioLogeado: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        obtenerDatosUsuario()
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        // Obtener datos actualizados
        guard let id = usuarioLogeado["id"] as? Int,
            let nombre = txtNombre.text,
            let clave = txtClave.text,
            let email = txtEmail.text else { return }
            // Crear el objeto Users con los datos actualizados
            let datosActualizados = Users(id: id, nombre: nombre, clave: clave, email: email)
            // Llamar a la función para actualizar los datos en el servidor
            actualizarPerfilUsuario(usuario: datosActualizados)
    }
    
    func obtenerDatosUsuario() {
        // Recuperar los datos del usuario logeado desde UserDefaults
        if let usuario = UserDefaults.standard.value(forKey: "usuarioLogeado") as? [String: Any] {
            self.usuarioLogeado = usuario
            let nombre = usuario["nombre"] as? String ?? ""
            let clave = usuario["clave"] as? String ?? ""
            let email = usuario["email"] as? String ?? ""

            // Mostrar los datos en los TextFields
            txtNombre.text = nombre
            txtClave.text = clave
            txtEmail.text = email
        } else {
            print("No se encontró el usuario logeado")
        }
    }

    func actualizarPerfilUsuario(usuario: Users) {
        // URL del servidor JSON
        guard let url = URL(string: "http://localhost:3000/usuarios/\(usuario.id)") else { return }
        // Crear la solicitud PATCH
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Convertir el objeto Users a JSON usando JSONEncoder
        do {
            let jsonData = try JSONEncoder().encode(usuario)
            request.httpBody = jsonData
        } catch {
            print("Error al convertir datos a JSON: \(error)")
            return
        }
        // Enviar la solicitud
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al actualizar el perfil: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error en la respuesta del servidor")
                return
            }
            DispatchQueue.main.async {
                self.mostrarAlerta(titulo: "Éxito", mensaje: "Perfil actualizado correctamente", accion: "OK")
            }
        }
        task.resume()
    }

    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
}
