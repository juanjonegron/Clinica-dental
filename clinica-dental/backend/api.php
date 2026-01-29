<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

// Configuración de la base de datos
$host = getenv('DB_HOST') ?: 'db';
$dbname = getenv('DB_NAME') ?: 'centro_dental';
$user = getenv('DB_USER') ?: 'dental_user';
$password = getenv('DB_PASSWORD') ?: 'dental_pass';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Error de conexión: ' . $e->getMessage()]);
    exit;
}

// Obtener parámetros de búsqueda
$action = $_GET['action'] ?? '';
$search = $_GET['search'] ?? '';

switch ($action) {
    case 'buscar_pacientes':
        buscarPacientes($pdo, $search);
        break;
    case 'buscar_dentistas':
        buscarDentistas($pdo, $search);
        break;
    case 'buscar_citas':
        buscarCitas($pdo, $search);
        break;
    case 'obtener_paciente':
        obtenerPaciente($pdo, $search);
        break;
    case 'obtener_dentista':
        obtenerDentista($pdo, $search);
        break;
    case 'estadisticas':
        obtenerEstadisticas($pdo);
        break;
    default:
        echo json_encode(['error' => 'Acción no válida']);
}

function buscarPacientes($pdo, $search) {
    $query = "SELECT * FROM paciente WHERE 
              Nombre LIKE :search OR 
              Rut_Paciente LIKE :search OR 
              Correo LIKE :search OR 
              Telefono LIKE :search 
              ORDER BY Nombre";
    
    $stmt = $pdo->prepare($query);
    $searchParam = "%$search%";
    $stmt->bindParam(':search', $searchParam);
    $stmt->execute();
    
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function buscarDentistas($pdo, $search) {
    $query = "SELECT * FROM dentistas WHERE 
              Nombre LIKE :search OR 
              Rut_Dentista LIKE :search OR 
              Especialidad LIKE :search OR 
              Correo LIKE :search 
              ORDER BY Nombre";
    
    $stmt = $pdo->prepare($query);
    $searchParam = "%$search%";
    $stmt->bindParam(':search', $searchParam);
    $stmt->execute();
    
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function buscarCitas($pdo, $search) {
    $query = "SELECT c.*, p.Nombre as NombrePaciente, d.Nombre as NombreDentista 
              FROM citas c 
              INNER JOIN paciente p ON c.Rut_Paciente = p.Rut_Paciente 
              INNER JOIN dentistas d ON c.Rut_Dentista = d.Rut_Dentista 
              WHERE p.Nombre LIKE :search OR 
                    d.Nombre LIKE :search OR 
                    c.Rut_Paciente LIKE :search OR 
                    c.FechaCita LIKE :search OR 
                    c.TipoAtencion LIKE :search 
              ORDER BY c.FechaCita DESC";
    
    $stmt = $pdo->prepare($query);
    $searchParam = "%$search%";
    $stmt->bindParam(':search', $searchParam);
    $stmt->execute();
    
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

function obtenerPaciente($pdo, $rut) {
    // Datos del paciente
    $stmt = $pdo->prepare("SELECT * FROM paciente WHERE Rut_Paciente = :rut");
    $stmt->bindParam(':rut', $rut);
    $stmt->execute();
    $paciente = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$paciente) {
        echo json_encode(['error' => 'Paciente no encontrado']);
        return;
    }
    
    // Problemas del paciente
    $stmt = $pdo->prepare("SELECT * FROM problemas WHERE Rut_Paciente = :rut");
    $stmt->bindParam(':rut', $rut);
    $stmt->execute();
    $problemas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Citas del paciente
    $stmt = $pdo->prepare("SELECT c.*, d.Nombre as NombreDentista 
                          FROM citas c 
                          INNER JOIN dentistas d ON c.Rut_Dentista = d.Rut_Dentista 
                          WHERE c.Rut_Paciente = :rut 
                          ORDER BY c.FechaCita DESC");
    $stmt->bindParam(':rut', $rut);
    $stmt->execute();
    $citas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'paciente' => $paciente,
        'problemas' => $problemas,
        'citas' => $citas
    ]);
}

function obtenerDentista($pdo, $rut) {
    // Datos del dentista
    $stmt = $pdo->prepare("SELECT * FROM dentistas WHERE Rut_Dentista = :rut");
    $stmt->bindParam(':rut', $rut);
    $stmt->execute();
    $dentista = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$dentista) {
        echo json_encode(['error' => 'Dentista no encontrado']);
        return;
    }
    
    // Citas del dentista
    $stmt = $pdo->prepare("SELECT c.*, p.Nombre as NombrePaciente 
                          FROM citas c 
                          INNER JOIN paciente p ON c.Rut_Paciente = p.Rut_Paciente 
                          WHERE c.Rut_Dentista = :rut 
                          ORDER BY c.FechaCita DESC");
    $stmt->bindParam(':rut', $rut);
    $stmt->execute();
    $citas = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'dentista' => $dentista,
        'citas' => $citas
    ]);
}

function obtenerEstadisticas($pdo) {
    // Total de pacientes
    $totalPacientes = $pdo->query("SELECT COUNT(*) as total FROM paciente")->fetch(PDO::FETCH_ASSOC)['total'];
    
    // Total de dentistas
    $totalDentistas = $pdo->query("SELECT COUNT(*) as total FROM dentistas")->fetch(PDO::FETCH_ASSOC)['total'];
    
    // Total de citas
    $totalCitas = $pdo->query("SELECT COUNT(*) as total FROM citas")->fetch(PDO::FETCH_ASSOC)['total'];
    
    // Saldo total pendiente
    $saldoPendiente = $pdo->query("SELECT SUM(Saldo) as total FROM citas")->fetch(PDO::FETCH_ASSOC)['total'];
    
    // Citas por especialidad
    $citasPorEspecialidad = $pdo->query("SELECT d.Especialidad, COUNT(*) as cantidad 
                                        FROM citas c 
                                        INNER JOIN dentistas d ON c.Rut_Dentista = d.Rut_Dentista 
                                        GROUP BY d.Especialidad 
                                        ORDER BY cantidad DESC")->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'totalPacientes' => $totalPacientes,
        'totalDentistas' => $totalDentistas,
        'totalCitas' => $totalCitas,
        'saldoPendiente' => $saldoPendiente,
        'citasPorEspecialidad' => $citasPorEspecialidad
    ]);
}
?>
