PSL64 := SL(6,4) / Centre(SL(6,4));
PSL67 := SL(6,7) / Centre(SL(6,7));
S := PSL67;
P := SylowSubgroup(S, 3);
Print(IsAbelian(P/Centre(P)));
