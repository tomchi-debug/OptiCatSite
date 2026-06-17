# Project Instructions: Opticat (HVAC Service Pro)

Opticat is a comprehensive HVAC (Heating, Ventilation, and Air Conditioning) service and design platform. It is an offline-first, mobile-centric application designed for field technicians to perform inspections, balancing, and system design with integrated physics-based simulations.

## Project Domain: HVAC & Energy Systems
- **Core Entities:** Projects, Buildings, and "Aggregat" (Air Handling Units/Systems).
- **Key Workflows:** Service checklists, OVK (inspections), Balancing (Injustering), Design (Projektering), and CFD Simulations.
- **Data Model:** Offline-first JSON-based local storage.

## Technical Architecture
- **Language:** TypeScript
- **Framework:** React
- **Physics Engine:** Network-based airside solvers, acoustics, and WebGPU-based CFD.
- **Data Flow:** Module interaction via shared file-system JSON stores.

## Conventions
- **Naming:** Follow established HVAC terminology (Swedish/English as per docs).
- **Testing:** TDD for calculation engines and data synchronization logic.
- **Documentation:** Maintain whitepapers and technical plans in `thoughts/opticat/docs`.
