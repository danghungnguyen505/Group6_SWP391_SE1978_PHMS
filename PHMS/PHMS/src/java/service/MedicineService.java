/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import model.Medicine;
import java.util.List;

public interface MedicineService {
    List<Medicine> getAllMedicines();
    Medicine getMedicineById(int id);
    void addMedicine(Medicine m);
    void updateMedicine(Medicine m);
    void deleteMedicine(int id);
}

