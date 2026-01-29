// Configuración
const API_URL = '/api/api.php';

// Estado de la aplicación
let currentTab = 'pacientes';

// Elementos del DOM
const searchInput = document.getElementById('searchInput');
const searchBtn = document.getElementById('searchBtn');
const resultsContainer = document.getElementById('results');
const modal = document.getElementById('modal');
const modalBody = document.getElementById('modalBody');
const closeModal = document.querySelector('.close');
const tabButtons = document.querySelectorAll('.tab-btn');

// Inicialización
document.addEventListener('DOMContentLoaded', () => {
    cargarEstadisticas();
    
    // Event listeners para tabs
    tabButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            tabButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            currentTab = btn.dataset.tab;
            resultsContainer.innerHTML = '<div class="empty-state"><p> Realiza una búsqueda</p></div>';
        });
    });
    
    // Event listener para búsqueda
    searchBtn.addEventListener('click', realizarBusqueda);
    searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            realizarBusqueda();
        }
    });
    
    // Event listener para cerrar modal
    closeModal.addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
});

// Cargar estadísticas
async function cargarEstadisticas() {
    try {
        const response = await fetch(`${API_URL}?action=estadisticas`);
        const data = await response.json();
        
        if (data.error) {
            console.error('Error:', data.error);
            return;
        }
        
        document.getElementById('totalPacientes').textContent = data.totalPacientes;
        document.getElementById('totalDentistas').textContent = data.totalDentistas;
        document.getElementById('totalCitas').textContent = data.totalCitas;
        document.getElementById('saldoPendiente').textContent = 
            new Intl.NumberFormat('es-CL', { style: 'currency', currency: 'CLP' }).format(data.saldoPendiente);
    } catch (error) {
        console.error('Error al cargar estadísticas:', error);
    }
}

// Realizar búsqueda
async function realizarBusqueda() {
    const searchTerm = searchInput.value.trim();
    
    resultsContainer.innerHTML = '<div class="loading">⏳ Buscando...</div>';
    
    try {
        let action = '';
        switch (currentTab) {
            case 'pacientes':
                action = 'buscar_pacientes';
                break;
            case 'dentistas':
                action = 'buscar_dentistas';
                break;
            case 'citas':
                action = 'buscar_citas';
                break;
        }
        
        const response = await fetch(`${API_URL}?action=${action}&search=${encodeURIComponent(searchTerm)}`);
        const data = await response.json();
        
        if (data.error) {
            resultsContainer.innerHTML = `<div class="error">${data.error}</div>`;
            return;
        }
        
        mostrarResultados(data);
    } catch (error) {
        resultsContainer.innerHTML = '<div class="error">Error al realizar la búsqueda</div>';
        console.error('Error:', error);
    }
}

// Mostrar resultados
function mostrarResultados(data) {
    if (!data || data.length === 0) {
        resultsContainer.innerHTML = '<div class="empty-state"><p>No se encontraron resultados</p></div>';
        return;
    }
    
    let html = '<div class="result-grid">';
    
    switch (currentTab) {
        case 'pacientes':
            html += data.map(paciente => `
                <div class="result-card" onclick="verDetallePaciente('${paciente.Rut_Paciente}')">
                    <h3>${paciente.Nombre}</h3>
                    <p><strong>RUT:</strong> ${paciente.Rut_Paciente}</p>
                    <p><strong>Fecha Nacimiento:</strong> ${formatearFecha(paciente.FechaNacimiento)}</p>
                    <p><strong>Teléfono:</strong> ${paciente.Telefono}</p>
                    <p><strong>Email:</strong> ${paciente.Correo}</p>
                    <p><strong>Dirección:</strong> ${paciente.Calle} ${paciente.Numero}</p>
                </div>
            `).join('');
            break;
            
        case 'dentistas':
            html += data.map(dentista => `
                <div class="result-card" onclick="verDetalleDentista('${dentista.Rut_Dentista}')">
                    <h3>${dentista.Nombre}</h3>
                    <p><strong>RUT:</strong> ${dentista.Rut_Dentista}</p>
                    <p><strong>Especialidad:</strong> ${dentista.Especialidad}</p>
                    <p><strong>Teléfono:</strong> ${dentista.Telefono}</p>
                    <p><strong>Email:</strong> ${dentista.Correo}</p>
                </div>
            `).join('');
            break;
            
        case 'citas':
            html = '<div class="table-container"><table>';
            html += `
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Paciente</th>
                        <th>Dentista</th>
                        <th>Tipo</th>
                        <th>Monto Total</th>
                        <th>Saldo</th>
                        <th>Observaciones</th>
                    </tr>
                </thead>
                <tbody>
            `;
            html += data.map(cita => `
                <tr>
                    <td>${formatearFecha(cita.FechaCita)}</td>
                    <td>${cita.NombrePaciente}</td>
                    <td>${cita.NombreDentista}</td>
                    <td>${cita.TipoAtencion}</td>
                    <td>${formatearMoneda(cita.Monto_Total)}</td>
                    <td>${formatearMoneda(cita.Saldo)}</td>
                    <td>${cita.Observaciones}</td>
                </tr>
            `).join('');
            html += '</tbody></table></div>';
            break;
    }
    
    if (currentTab !== 'citas') {
        html += '</div>';
    }
    
    resultsContainer.innerHTML = html;
}

// Ver detalle de paciente
async function verDetallePaciente(rut) {
    try {
        const response = await fetch(`${API_URL}?action=obtener_paciente&search=${rut}`);
        const data = await response.json();
        
        if (data.error) {
            alert(data.error);
            return;
        }
        
        const paciente = data.paciente;
        const problemas = data.problemas;
        const citas = data.citas;
        
        let html = `
            <div class="detail-section">
                <h2>Información del Paciente</h2>
                <div class="detail-grid">
                    <div class="detail-item"><strong>Nombre:</strong> ${paciente.Nombre}</div>
                    <div class="detail-item"><strong>RUT:</strong> ${paciente.Rut_Paciente}</div>
                    <div class="detail-item"><strong>Fecha Nacimiento:</strong> ${formatearFecha(paciente.FechaNacimiento)}</div>
                    <div class="detail-item"><strong>Teléfono:</strong> ${paciente.Telefono}</div>
                    <div class="detail-item"><strong>Email:</strong> ${paciente.Correo}</div>
                    <div class="detail-item"><strong>Dirección:</strong> ${paciente.Calle} ${paciente.Numero}</div>
                </div>
            </div>
        `;
        
        if (problemas && problemas.length > 0) {
            html += `
                <div class="detail-section">
                    <h2>Problemas Dentales</h2>
                    ${problemas.map(p => `
                        <div class="detail-item">
                            <strong>Problema #${p.IdProblema}:</strong> ${p.Descripcion}
                        </div>
                    `).join('')}
                </div>
            `;
        }
        
        if (citas && citas.length > 0) {
            html += `
                <div class="detail-section">
                    <h2>Historial de Citas</h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Dentista</th>
                                    <th>Tipo</th>
                                    <th>Monto Total</th>
                                    <th>Abonado</th>
                                    <th>Saldo</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${citas.map(c => `
                                    <tr>
                                        <td>${formatearFecha(c.FechaCita)}</td>
                                        <td>${c.NombreDentista}</td>
                                        <td>${c.TipoAtencion}</td>
                                        <td>${formatearMoneda(c.Monto_Total)}</td>
                                        <td>${formatearMoneda(c.Monto_Abonado)}</td>
                                        <td>${formatearMoneda(c.Saldo)}</td>
                                        <td>${c.Observaciones}</td>
                                    </tr>
                                `).join('')}
                            </tbody>
                        </table>
                    </div>
                </div>
            `;
        }
        
        modalBody.innerHTML = html;
        modal.style.display = 'block';
    } catch (error) {
        console.error('Error:', error);
        alert('Error al cargar detalles del paciente');
    }
}

// Ver detalle de dentista
async function verDetalleDentista(rut) {
    try {
        const response = await fetch(`${API_URL}?action=obtener_dentista&search=${rut}`);
        const data = await response.json();
        
        if (data.error) {
            alert(data.error);
            return;
        }
        
        const dentista = data.dentista;
        const citas = data.citas;
        
        let html = `
            <div class="detail-section">
                <h2>Información del Dentista</h2>
                <div class="detail-grid">
                    <div class="detail-item"><strong>Nombre:</strong> ${dentista.Nombre}</div>
                    <div class="detail-item"><strong>RUT:</strong> ${dentista.Rut_Dentista}</div>
                    <div class="detail-item"><strong>Especialidad:</strong> ${dentista.Especialidad}</div>
                    <div class="detail-item"><strong>Teléfono:</strong> ${dentista.Telefono}</div>
                    <div class="detail-item"><strong>Email:</strong> ${dentista.Correo}</div>
                </div>
            </div>
        `;
        
        if (citas && citas.length > 0) {
            html += `
                <div class="detail-section">
                    <h2>Historial de Atenciones</h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Fecha</th>
                                    <th>Paciente</th>
                                    <th>Tipo</th>
                                    <th>Monto Total</th>
                                    <th>Saldo</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${citas.map(c => `
                                    <tr>
                                        <td>${formatearFecha(c.FechaCita)}</td>
                                        <td>${c.NombrePaciente}</td>
                                        <td>${c.TipoAtencion}</td>
                                        <td>${formatearMoneda(c.Monto_Total)}</td>
                                        <td>${formatearMoneda(c.Saldo)}</td>
                                        <td>${c.Observaciones}</td>
                                    </tr>
                                `).join('')}
                            </tbody>
                        </table>
                    </div>
                </div>
            `;
        }
        
        modalBody.innerHTML = html;
        modal.style.display = 'block';
    } catch (error) {
        console.error('Error:', error);
        alert('Error al cargar detalles del dentista');
    }
}

// Funciones auxiliares
function formatearFecha(fecha) {
    if (!fecha) return 'N/A';
    const date = new Date(fecha + 'T00:00:00');
    return date.toLocaleDateString('es-CL', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    });
}

function formatearMoneda(monto) {
    if (!monto) return '$0';
    return new Intl.NumberFormat('es-CL', { 
        style: 'currency', 
        currency: 'CLP' 
    }).format(monto);
}
