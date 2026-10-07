allDays ← {∾⟨"day",•Fmt 𝕩,".bqn"⟩}¨1+↕25
completed ← (•file.Exists¨allDays) / allDays
•Import¨completed