-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         12.2.1-MariaDB - MariaDB Server
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS centro_dental;
USE centro_dental;

-- Creación de tabla paciente
CREATE TABLE IF NOT EXISTS `paciente` (
  `Rut_Paciente` varchar(12) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `FechaNacimiento` date NOT NULL,
  `Calle` varchar(100),
  `Numero` varchar(10),
  `Telefono` varchar(15),
  `Correo` varchar(100),
  PRIMARY KEY (`Rut_Paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de tabla dentistas
CREATE TABLE IF NOT EXISTS `dentistas` (
  `Rut_Dentista` varchar(12) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Especialidad` varchar(50),
  `Telefono` varchar(15),
  `Correo` varchar(100),
  PRIMARY KEY (`Rut_Dentista`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de tabla problemas
CREATE TABLE IF NOT EXISTS `problemas` (
  `IdProblema` int(11) NOT NULL AUTO_INCREMENT,
  `Rut_Paciente` varchar(12) NOT NULL,
  `Descripcion` text,
  PRIMARY KEY (`IdProblema`),
  KEY `Rut_Paciente` (`Rut_Paciente`),
  CONSTRAINT `problemas_ibfk_1` FOREIGN KEY (`Rut_Paciente`) REFERENCES `paciente` (`Rut_Paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Creación de tabla citas
CREATE TABLE IF NOT EXISTS `citas` (
  `Id_cita` int(11) NOT NULL AUTO_INCREMENT,
  `Rut_Paciente` varchar(12) NOT NULL,
  `Rut_Dentista` varchar(12) NOT NULL,
  `FechaCita` date NOT NULL,
  `TipoAtencion` varchar(50),
  `Observaciones` text,
  `Monto_Total` decimal(10,2),
  `Monto_Abonado` decimal(10,2),
  `Saldo` decimal(10,2),
  PRIMARY KEY (`Id_cita`),
  KEY `Rut_Paciente` (`Rut_Paciente`),
  KEY `Rut_Dentista` (`Rut_Dentista`),
  CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`Rut_Paciente`) REFERENCES `paciente` (`Rut_Paciente`),
  CONSTRAINT `citas_ibfk_2` FOREIGN KEY (`Rut_Dentista`) REFERENCES `dentistas` (`Rut_Dentista`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Volcando datos para la tabla centro_dental.paciente: ~10 rows (aproximadamente)
INSERT INTO `paciente` (`Rut_Paciente`, `Nombre`, `FechaNacimiento`, `Calle`, `Numero`, `Telefono`, `Correo`) VALUES
	('11111111-1', 'Ana Pérez', '1990-05-12', 'Av. Siempre Viva', '123', '912345678', 'ana.perez@mail.com'),
	('22222222-2', 'Luis Gómez', '1985-03-22', 'Calle Los Olmos', '456', '987654321', 'luis.gomez@mail.com'),
	('33333333-3', 'María Torres', '1992-07-15', 'Pasaje Las Rosas', '789', '956789123', 'maria.torres@mail.com'),
	('44444444-4', 'Pedro Ramírez', '1980-11-30', 'Av. Central', '321', '934567890', 'pedro.ramirez@mail.com'),
	('55555555-5', 'Carolina Díaz', '1995-01-05', 'Calle Norte', '654', '923456789', 'carolina.diaz@mail.com'),
	('66666666-6', 'Jorge Silva', '1988-09-10', 'Av. Sur', '987', '945612378', 'jorge.silva@mail.com'),
	('77777777-7', 'Valentina Rojas', '1993-12-25', 'Calle Oriente', '741', '978456123', 'valentina.rojas@mail.com'),
	('88888888-8', 'Felipe Herrera', '1987-04-18', 'Av. Poniente', '852', '932145678', 'felipe.herrera@mail.com'),
	('99999999-9', 'Camila Castro', '1991-06-09', 'Pasaje Azul', '963', '967812345', 'camila.castro@mail.com'),
	('10101010-0', 'Rodrigo Morales', '1984-02-14', 'Av. Verde', '159', '976543210', 'rodrigo.morales@mail.com');

-- Volcando datos para la tabla centro_dental.dentistas: ~5 rows (aproximadamente)
INSERT INTO `dentistas` (`Rut_Dentista`, `Nombre`, `Especialidad`, `Telefono`, `Correo`) VALUES
	('12121212-1', 'Dr. Juan Soto', 'Ortodoncia', '965415357', 'juan.soto@mail.com'),
	('13131313-2', 'Dra. Paula Fuentes', 'Endodoncia', '987654321', 'paula.fuentes@mail.com'),
	('14141414-3', 'Dr. Andrés López', 'Implantología', '952314783', 'andres.lopez@mail.com'),
	('15151515-4', 'Dra. Sofía Martínez', 'Odontopediatría', '963852741', 'sofia.martinez@mail.com'),
	('16161616-5', 'Dr. Carlos Vega', 'Periodoncia', '951789456', 'carlos.vega@mail.com');

-- Volcando datos para la tabla centro_dental.problemas: ~10 rows (aproximadamente)
INSERT INTO `problemas` (`IdProblema`, `Rut_Paciente`, `Descripcion`) VALUES
	(1, '11111111-1', 'Caries en molar'),
	(2, '22222222-2', 'Tratamiento de ortodoncia'),
	(3, '33333333-3', 'Endodoncia en premolar'),
	(4, '44444444-4', 'Implante dental'),
	(5, '55555555-5', 'Limpieza profunda'),
	(6, '66666666-6', 'Extracción de muela del juicio'),
	(7, '77777777-7', 'Sensibilidad dental'),
	(8, '88888888-8', 'Periodontitis'),
	(9, '99999999-9', 'Blanqueamiento dental'),
	(10, '10101010-0', 'Revisión general');

-- Volcando datos para la tabla centro_dental.citas: ~20 rows (aproximadamente)
INSERT INTO `citas` (`Id_cita`, `Rut_Paciente`, `Rut_Dentista`, `FechaCita`, `TipoAtencion`, `Observaciones`, `Monto_Total`, `Monto_Abonado`, `Saldo`) VALUES
	(1, '11111111-1', '12121212-1', '2025-01-10', 'Primera', 'Paciente con dolor leve', 50000.00, 20000.00, 30000.00),
	(2, '11111111-1', '12121212-1', '2025-02-15', 'Continuacion', 'Control ortodoncia', 50000.00, 30000.00, 20000.00),
	(3, '22222222-2', '12121212-1', '2025-01-12', 'Primera', 'Inicio tratamiento ortodoncia', 80000.00, 40000.00, 40000.00),
	(4, '22222222-2', '12121212-1', '2025-02-20', 'Continuacion', 'Ajuste brackets', 80000.00, 20000.00, 60000.00),
	(5, '33333333-3', '13131313-2', '2025-01-18', 'Primera', 'Endodoncia premolar', 60000.00, 30000.00, 30000.00),
	(6, '33333333-3', '13131313-2', '2025-02-25', 'Continuacion', 'Revisión endodoncia', 60000.00, 20000.00, 40000.00),
	(7, '44444444-4', '14141414-3', '2025-01-22', 'Primera', 'Implante dental', 120000.00, 60000.00, 60000.00),
	(8, '44444444-4', '14141414-3', '2025-03-01', 'Continuacion', 'Control implante', 120000.00, 30000.00, 90000.00),
	(9, '55555555-5', '15151515-4', '2025-01-25', 'Primera', 'Limpieza profunda', 40000.00, 20000.00, 20000.00),
	(10, '55555555-5', '15151515-4', '2025-02-28', 'Continuacion', 'Revisión limpieza', 40000.00, 10000.00, 30000.00),
	(11, '66666666-6', '14141414-3', '2025-01-30', 'Primera', 'Extracción muela juicio', 70000.00, 40000.00, 30000.00),
	(12, '66666666-6', '14141414-3', '2025-03-05', 'Continuacion', 'Revisión post extracción', 70000.00, 20000.00, 50000.00),
	(13, '77777777-7', '16161616-5', '2025-02-02', 'Primera', 'Sensibilidad dental', 30000.00, 15000.00, 15000.00),
	(14, '77777777-7', '16161616-5', '2025-03-10', 'Continuacion', 'Control sensibilidad', 30000.00, 10000.00, 20000.00),
	(15, '88888888-8', '16161616-5', '2025-02-05', 'Primera', 'Periodontitis avanzada', 90000.00, 50000.00, 40000.00),
	(16, '88888888-8', '16161616-5', '2025-03-15', 'Continuacion', 'Tratamiento periodontal', 90000.00, 30000.00, 60000.00),
	(17, '99999999-9', '15151515-4', '2025-02-08', 'Primera', 'Blanqueamiento dental', 60000.00, 30000.00, 30000.00),
	(18, '99999999-9', '15151515-4', '2025-03-20', 'Continuacion', 'Control blanqueamiento', 60000.00, 20000.00, 40000.00),
	(19, '10101010-0', '12121212-1', '2025-02-12', 'Primera', 'Revisión general', 20000.00, 10000.00, 10000.00),
	(20, '10101010-0', '12121212-1', '2025-03-25', 'Continuacion', 'Control revisión', 20000.00, 5000.00, 15000.00);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
