SELECT
  T1.question AS 'Infant & Young Child Feeding',
  SUM(T1.Count) AS Count
From
(SELECT
  If(onlyBreastFeeding.question_full_name = 'Nutrition-Only breast feeding for 6 months', 'Excl. breast feeding',
     'Complementary feeding')                 AS question,
  COUNT(DISTINCT onlyBreastFeeding.person_id) AS Count

FROM person p
  JOIN nonVoidedQuestionAnswerObs onlyBreastFeeding ON (onlyBreastFeeding.person_id = p.person_id)
  JOIN person_address address ON p.person_id = address.person_id
WHERE !p.voided AND
      DATE(onlyBreastFeeding.obs_datetime) BETWEEN DATE('#startDate#') AND DATE('#endDate#')
      AND (onlyBreastFeeding.question_full_name IN
           ('Nutrition-Only breast feeding for 6 months', 'Nutrition-Breast feeding and light food'))
      AND address.address1 ='10'
GROUP BY question
UNION ALL SELECT 'Excl. breast feeding', 0
UNION ALL SELECT 'Complementary feeding', 0
) as T1
GROUP BY question
ORDER BY question desc;
