allDays ← {∾⟨"day",•Fmt 𝕩,".bqn"⟩}¨1+↕25
completed ← (•file.Exists¨allDays) / allDays
t_us ← •Import¨completed

•Out "Total: "∾•Fmt +´t_us
•Out "Grand total: "∾•Fmt +´+´t_us