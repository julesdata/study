## 175. Combine Two Tables
### \<Problem\>

![image](https://user-images.githubusercontent.com/74705142/110563205-4a7d5900-818e-11eb-980e-70ae673411b5.png)

### \<Solving\>

#### My Answer

```sql
select A.FirstName,A.LastName, B.City, B.State
from Person as A left join Address as B 
                    on A.PersonId = B.PersonId;
```
![image](https://user-images.githubusercontent.com/74705142/110563873-4867ca00-818f-11eb-901f-85dd0289003b.png)

