/* ---------------------------------------------------- */
/*  Generated by Enterprise Architect Version 13.5 		*/
/*  Created On : 23-Apr-2018 10:25:10 				*/
/*  DBMS       : SQLite 								*/
/* ---------------------------------------------------- */

/* Drop Tables */

DROP TABLE IF EXISTS 'Agent'
;

DROP TABLE IF EXISTS 'Equipment'
;

DROP TABLE IF EXISTS 'EquipmentSegmentSpecification'
;

DROP TABLE IF EXISTS 'EquipmentSpecificationProperty'
;

DROP TABLE IF EXISTS 'EquipmentUsedActual'
;

DROP TABLE IF EXISTS 'Event'
;

DROP TABLE IF EXISTS 'Financial'
;

DROP TABLE IF EXISTS 'FinancialFlow'
;

DROP TABLE IF EXISTS 'GoodsProducedActual'
;

DROP TABLE IF EXISTS 'Material'
;

DROP TABLE IF EXISTS 'MaterialFlow'
;

DROP TABLE IF EXISTS 'MaterialSegmentSpecification'
;

DROP TABLE IF EXISTS 'MaterialSpecificationProperty'
;

DROP TABLE IF EXISTS 'PersonelSegmentSpecification'
;

DROP TABLE IF EXISTS 'Personnel'
;

DROP TABLE IF EXISTS 'PersonnelSpecificationProperty'
;

DROP TABLE IF EXISTS 'PersonnelUsedActual'
;

DROP TABLE IF EXISTS 'ProcessParameters'
;

DROP TABLE IF EXISTS 'ProcessSegment'
;

DROP TABLE IF EXISTS 'RawMaterialUsedActual'
;

DROP TABLE IF EXISTS 'SegmentRequirement'
;

DROP TABLE IF EXISTS 'SegmentResponse'
;

/* Create Tables with Primary and Foreign Keys, Check and Unique Constraints */

CREATE TABLE 'Agent'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL
)
;

CREATE TABLE 'Equipment'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'pricePerUnit' NUMERIC NULL,
	'priceUoM' TEXT NULL
)
;

CREATE TABLE 'EquipmentSegmentSpecification'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'prodCoeff' NUMERIC NULL,
	'coeffUoM' TEXT NULL,
	'procSegID' INTEGER NULL,
	CONSTRAINT 'FK_EquipmentSegmentSpecification_ProcessSegment' FOREIGN KEY ('procSegID') REFERENCES 'ProcessSegment' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'EquipmentSpecificationProperty'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'equSegSpecID' INTEGER NULL,
	'equID' INTEGER NULL,
	CONSTRAINT 'FK_EquipmentSpecificationProperty_Equipment' FOREIGN KEY ('equID') REFERENCES 'Equipment' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_EquipmentSpecificationProperty_EquipmentSegmentSpecification' FOREIGN KEY ('equSegSpecID') REFERENCES 'EquipmentSegmentSpecification' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'EquipmentUsedActual'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'equID' INTEGER NULL,
	'usedQuantity' NUMERIC NULL,
	'segRespID' INTEGER NULL,
	CONSTRAINT 'FK_EquipmentUsedActual_Equipment' FOREIGN KEY ('equID') REFERENCES 'Equipment' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_EquipmentUsedActual_SegmentResponse' FOREIGN KEY ('segRespID') REFERENCES 'SegmentResponse' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'Event'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'timestamp' TEXT NULL,
	'fromAgent' INTEGER NULL,
	'toAgent' INTEGER NULL,
	'dualEvent' INTEGER NULL,
	CONSTRAINT 'FK_Event_Agent' FOREIGN KEY ('toAgent') REFERENCES 'Agent' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_Event_Agent_02' FOREIGN KEY ('fromAgent') REFERENCES 'Agent' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_Event_Event' FOREIGN KEY ('dualEvent') REFERENCES 'Event' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'Financial'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'pricePerUnit' NUMERIC NULL,
	'priceUoM' TEXT NULL,
	'actualStock' NUMERIC NULL,
	'stockUoM' TEXT NULL
)
;

CREATE TABLE 'FinancialFlow'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'quantity' NUMERIC NULL,
	'value' NUMERIC NULL,
	'finID' INTEGER NULL,
	'eventID' INTEGER NULL,
	CONSTRAINT 'FK_FinancialFlow_Event' FOREIGN KEY ('eventID') REFERENCES 'Event' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_FinancialFlow_Financial' FOREIGN KEY ('finID') REFERENCES 'Financial' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'GoodsProducedActual'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'matID' INTEGER NULL,
	'producedQuantity' NUMERIC NULL,
	'segRespID' INTEGER NULL,
	CONSTRAINT 'FK_GoodsProducedActual_Material' FOREIGN KEY ('matID') REFERENCES 'Material' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_GoodsProducedActual_SegmentResponse' FOREIGN KEY ('segRespID') REFERENCES 'SegmentResponse' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'Material'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'pricePerUnit' NUMERIC NULL,
	'priceUoM' TEXT NULL,
	'actualStock' NUMERIC NULL,
	'stockUoM' TEXT NULL
)
;

CREATE TABLE 'MaterialFlow'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'quantity' NUMERIC NULL,
	'value' NUMERIC NULL,
	'matID' INTEGER NULL,
	'eventID' INTEGER NULL,
	CONSTRAINT 'FK_MaterialFlow_Event' FOREIGN KEY ('eventID') REFERENCES 'Event' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_MaterialFlow_Material' FOREIGN KEY ('matID') REFERENCES 'Material' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'MaterialSegmentSpecification'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'prodCoeff' NUMERIC NULL,
	'coeffUoM' TEXT NULL,
	'procSegID' INTEGER NULL,
	CONSTRAINT 'FK_MaterialSegmentSpecification_ProcessSegment' FOREIGN KEY ('procSegID') REFERENCES 'ProcessSegment' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'MaterialSpecificationProperty'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'matSegSpecID' INTEGER NULL,
	'matID' INTEGER NULL,
	CONSTRAINT 'FK_MaterialSpecificationProperty_Material' FOREIGN KEY ('matID') REFERENCES 'Material' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_MaterialSpecificationProperty_MaterialSegmentSpecification' FOREIGN KEY ('matSegSpecID') REFERENCES 'MaterialSegmentSpecification' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'PersonelSegmentSpecification'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'inputRatio' NUMERIC NULL,
	'ratioUoM' TEXT NULL,
	'procSegID' INTEGER NULL,
	CONSTRAINT 'FK_PersonelSegmentSpecification_ProcessSegment' FOREIGN KEY ('procSegID') REFERENCES 'ProcessSegment' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'Personnel'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'pricePerUnit' NUMERIC NULL,
	'priceUoM' TEXT NULL
)
;

CREATE TABLE 'PersonnelSpecificationProperty'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'property' TEXT NULL,
	'propValue' TEXT NULL,
	'persSegSpecID' INTEGER NULL,
	'persID' INTEGER NULL,
	CONSTRAINT 'FK_PersonnelSpecificationProperty_PersonelSegmentSpecification' FOREIGN KEY ('persSegSpecID') REFERENCES 'PersonelSegmentSpecification' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_PersonnelSpecificationProperty_Personnel' FOREIGN KEY ('persID') REFERENCES 'Personnel' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'PersonnelUsedActual'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'persID' INTEGER NULL,
	'usedQuantity' NUMERIC NULL,
	'segRespID' INTEGER NULL,
	CONSTRAINT 'FK_PersonnelUsedActual_Personnel' FOREIGN KEY ('persID') REFERENCES 'Personnel' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_PersonnelUsedActual_SegmentResponse' FOREIGN KEY ('segRespID') REFERENCES 'SegmentResponse' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'ProcessParameters'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'value' NUMERIC NULL,
	'UoM' TEXT NULL,
	'procSegID' INTEGER NULL,
	CONSTRAINT 'FK_ProcessParameters_ProcessSegment_02' FOREIGN KEY ('procSegID') REFERENCES 'ProcessSegment' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'ProcessSegment'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'duration' NUMERIC NULL,
	'durUoM' TEXT NULL,
	'processIO' TEXT NULL
)
;

CREATE TABLE 'RawMaterialUsedActual'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'description' TEXT NULL,
	'matID' INTEGER NULL,
	'consumedQuantity' NUMERIC NULL,
	'segRespID' INTEGER NULL,
	CONSTRAINT 'FK_RawMaterialUsedActual_Material' FOREIGN KEY ('segRespID') REFERENCES 'Material' ('id') ON DELETE No Action ON UPDATE No Action,
	CONSTRAINT 'FK_RawMaterialUsedActual_SegmentResponse' FOREIGN KEY ('segRespID') REFERENCES 'SegmentResponse' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'SegmentRequirement'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'startTimeScheduled' TEXT NULL,
	'endTimeScheduled' TEXT NULL,
	'procSegID' INTEGER NULL,
	CONSTRAINT 'FK_SegmentRequirement_ProcessSegment' FOREIGN KEY ('procSegID') REFERENCES 'ProcessSegment' ('id') ON DELETE No Action ON UPDATE No Action
)
;

CREATE TABLE 'SegmentResponse'
(
	'id' INTEGER NOT NULL PRIMARY KEY,
	'startTime' TEXT NULL,
	'endTime' TEXT NULL,
	'segReqID' INTEGER NULL,
	CONSTRAINT 'FK_SegmentResponse_SegmentRequirement' FOREIGN KEY ('segReqID') REFERENCES 'SegmentRequirement' ('id') ON DELETE No Action ON UPDATE No Action
)
;

/* Create Indexes and Triggers */

CREATE INDEX 'IXFK_EquipmentSegmentSpecification_ProcessSegment'
 ON 'EquipmentSegmentSpecification' ('procSegID' ASC)
;

CREATE INDEX 'IXFK_EquipmentSpecificationProperty_Equipment'
 ON 'EquipmentSpecificationProperty' ('equID' ASC)
;

CREATE INDEX 'IXFK_EquipmentSpecificationProperty_EquipmentSegmentSpecification'
 ON 'EquipmentSpecificationProperty' ('equSegSpecID' ASC)
;

CREATE INDEX 'IXFK_EquipmentUsedActual_Equipment'
 ON 'EquipmentUsedActual' ('equID' ASC)
;

CREATE INDEX 'IXFK_EquipmentUsedActual_SegmentResponse'
 ON 'EquipmentUsedActual' ('segRespID' ASC)
;

CREATE INDEX 'IXFK_Event_Agent'
 ON 'Event' ('toAgent' ASC)
;

CREATE INDEX 'IXFK_Event_Agent_02'
 ON 'Event' ('fromAgent' ASC)
;

CREATE INDEX 'IXFK_Event_Event'
 ON 'Event' ('dualEvent' ASC)
;

CREATE INDEX 'IXFK_FinancialFlow_Event'
 ON 'FinancialFlow' ('eventID' ASC)
;

CREATE INDEX 'IXFK_FinancialFlow_Financial'
 ON 'FinancialFlow' ('finID' ASC)
;

CREATE INDEX 'IXFK_GoodsProducedActual_Material'
 ON 'GoodsProducedActual' ('matID' ASC)
;

CREATE INDEX 'IXFK_GoodsProducedActual_SegmentResponse'
 ON 'GoodsProducedActual' ('segRespID' ASC)
;

CREATE INDEX 'IXFK_MaterialFlow_Event'
 ON 'MaterialFlow' ('eventID' ASC)
;

CREATE INDEX 'IXFK_MaterialFlow_Material'
 ON 'MaterialFlow' ('matID' ASC)
;

CREATE INDEX 'IXFK_MaterialSegmentSpecification_ProcessSegment'
 ON 'MaterialSegmentSpecification' ('procSegID' ASC)
;

CREATE INDEX 'IXFK_MaterialSpecificationProperty_Material'
 ON 'MaterialSpecificationProperty' ('matID' ASC)
;

CREATE INDEX 'IXFK_MaterialSpecificationProperty_MaterialSegmentSpecification'
 ON 'MaterialSpecificationProperty' ('matSegSpecID' ASC)
;

CREATE INDEX 'IXFK_PersonelSegmentSpecification_ProcessSegment'
 ON 'PersonelSegmentSpecification' ('procSegID' ASC)
;

CREATE INDEX 'IXFK_PersonnelSpecificationProperty_PersonelSegmentSpecification'
 ON 'PersonnelSpecificationProperty' ('persSegSpecID' ASC)
;

CREATE INDEX 'IXFK_PersonnelSpecificationProperty_Personnel'
 ON 'PersonnelSpecificationProperty' ('persID' ASC)
;

CREATE INDEX 'IXFK_PersonnelUsedActual_Personnel'
 ON 'PersonnelUsedActual' ('persID' ASC)
;

CREATE INDEX 'IXFK_PersonnelUsedActual_SegmentResponse'
 ON 'PersonnelUsedActual' ('segRespID' ASC)
;

CREATE INDEX 'IXFK_ProcessParameters_ProcessSegment'
 ON 'ProcessParameters' ('procSegID' ASC)
;

CREATE INDEX 'IXFK_ProcessParameters_ProcessSegment_02'
 ON 'ProcessParameters' ('procSegID' ASC)
;

CREATE INDEX 'IXFK_RawMaterialUsedActual_Material'
 ON 'RawMaterialUsedActual' ('segRespID' ASC)
;

CREATE INDEX 'IXFK_RawMaterialUsedActual_SegmentResponse'
 ON 'RawMaterialUsedActual' ('segRespID' ASC)
;

CREATE INDEX 'IXFK_SegmentRequirement_ProcessSegment'
 ON 'SegmentRequirement' ('procSegID' ASC)
;

CREATE INDEX 'IXFK_SegmentResponse_SegmentRequirement'
 ON 'SegmentResponse' ('segReqID' ASC)
;
