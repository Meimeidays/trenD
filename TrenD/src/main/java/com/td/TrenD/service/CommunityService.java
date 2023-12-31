package com.td.TrenD.service;

import com.td.TrenD.dao.CommunityRepository;
import com.td.TrenD.model.CategoryVO;
import com.td.TrenD.model.TrendVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import java.util.List;
import org.springframework.data.domain.Sort;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Service;
import javax.swing.tree.TreeNode;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class CommunityService {

    private final CommunityRepository commRepo;

    @Autowired
    public CommunityService(CommunityRepository repo) {
        this.commRepo = repo;
    }

    public List<TrendVO> commList() {
        return commRepo.commList();
    }

    public TrendVO commInsert(TrendVO trendVO) {
        return commRepo.save(trendVO);
    }

    public List<CategoryVO> findAllCategory() {
        return commRepo.findAllCategory();
    }
  
    public Page<TrendVO> findCommList(PageRequest pageable){
        return commRepo.findCommList(pageable);
    }

    public Page<TrendVO> findCategoryList(String cateCd, PageRequest pageable){
        return commRepo.findCategoryList(cateCd, pageable);
    }

    public Page<TrendVO> searchCommList(String keyword, String search, PageRequest pageable){
        return commRepo.searchCommList(keyword, search, pageable);
    }

    public int commUpdate(int trNo, String cateCd, String trSubject, String trContent, Date trUpdate) {
        return commRepo.commUpdate(trNo, cateCd, trSubject, trContent, trUpdate);
    }

    public TrendVO findById(int trNo){
        return commRepo.findById(trNo).get();
    }

}
