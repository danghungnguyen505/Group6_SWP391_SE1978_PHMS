/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Medicine;
import java.util.List;

public interface MedicineDAO {
    List<Medicine> findAll();
    Medicine findById(int id);
    void insert(Medicine m);
    void update(Medicine m);
    void delete(int id);
}
