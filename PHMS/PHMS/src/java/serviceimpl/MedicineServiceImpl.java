/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package serviceimpl;

import dao.MedicineDAO;
import daoimpl.MedicineDAOImpl;
import model.Medicine;
import service.MedicineService;

import java.util.List;

public class MedicineServiceImpl implements MedicineService {

    private MedicineDAO dao = new MedicineDAOImpl();

    @Override
    public List<Medicine> getAllMedicines() {
        return dao.findAll();
    }

    @Override
    public Medicine getMedicineById(int id) {
        return dao.findById(id);
    }

    @Override
    public void addMedicine(Medicine m) {
        dao.insert(m);
    }

    @Override
    public void updateMedicine(Medicine m) {
        dao.update(m);
    }

    @Override
    public void deleteMedicine(int id) {
        dao.delete(id);
    }
}
