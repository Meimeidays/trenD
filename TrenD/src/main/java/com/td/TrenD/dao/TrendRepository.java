package com.td.TrenD.dao;

import com.td.TrenD.model.TrendVO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrendRepository extends JpaRepository<TrendVO, Integer> {

    @Query("select t from TrendVO t join t.categoryVO c where t.trNo = :trNo")
    TrendVO trendContent(@Param("trNo") int trNo);


    @Query("SELECT c FROM TrendVO c WHERE c.trSubject LIKE concat( '%' , :keyword, '%') AND c.categoryVO.cateCd <> :cateCd AND c.trDelYn = 'n' ORDER BY c.trNo DESC")
    Page<TrendVO> commSearchResult(@Param("keyword") String keyword, @Param("cateCd") String cateCd, Pageable pageable);

    @Query("SELECT c FROM TrendVO c WHERE c.trSubject LIKE concat('%', :keyword, '%') AND c.categoryVO.cateCd = :cateCd AND c.trDelYn = 'n' ORDER BY c.trNo DESC")
    Page<TrendVO> trendSearchResult(@Param("keyword") String keyword, @Param("cateCd") String cateCd, Pageable pageable);

    int countTrendVOByCateCdContainingIgnoreCaseAndTrSubjectContainingAndTrDelYn(String cateCd, String keyword, char trDelYn);


    int countTrendVOByCateCdNotContainingIgnoreCaseAndTrSubjectContainingAndTrDelYn(String cateCd, String keyword, char trDelYn);



}
