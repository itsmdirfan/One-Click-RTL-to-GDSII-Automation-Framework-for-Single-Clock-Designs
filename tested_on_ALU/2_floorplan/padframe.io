(globals
version = 3
io_order = clockwise
space = 20 #Spacing between 2 IO pads
total_edge = 10
)

(iopad
(topleft
(inst name="CornerCell1" cell=pfrelr offset=0 orientation=R180 place_status=fixed )
)
(left
		( inst name="pclk" cell=pc3d01 place_status=fixed)
		( inst name="prst_n" cell=pc3d01 place_status=fixed)
		( inst name="pA_7" cell=pc3d01 place_status=fixed)
		( inst name="pA_6" cell=pc3d01 place_status=fixed)
		( inst name="pA_5" cell=pc3d01 place_status=fixed)
		( inst name="pA_4" cell=pc3d01 place_status=fixed)
		( inst name="pA_3" cell=pc3d01 place_status=fixed)
		( inst name="pA_2" cell=pc3d01 place_status=fixed)
		( inst name="pA_1" cell=pc3d01 place_status=fixed)
		( inst name="pA_0" cell=pc3d01 place_status=fixed)
)
(topright
(inst name="CornerCell2" cell=pfrelr offset=0 orientation=R90 place_status=fixed )
)
( top
		( inst name="pB_7" cell=pc3d01 place_status=fixed)
		( inst name="pB_6" cell=pc3d01 place_status=fixed)
		( inst name="pB_5" cell=pc3d01 place_status=fixed)
		( inst name="pB_4" cell=pc3d01 place_status=fixed)
		( inst name="pB_3" cell=pc3d01 place_status=fixed)
		( inst name="pB_2" cell=pc3d01 place_status=fixed)
		( inst name="pB_1" cell=pc3d01 place_status=fixed)
		( inst name="pB_0" cell=pc3d01 place_status=fixed)
		( inst name="pop_2" cell=pc3d01 place_status=fixed)
		( inst name="pop_1" cell=pc3d01 place_status=fixed)
)
(bottomright
(inst name="CornerCell3" cell=pfrelr offset=0 orientation=R0 place_status=fixed )
)
( right
		( inst name="pop_0" cell=pc3d01 place_status=fixed)
		( inst name="presult_7" cell=pc3o01 place_status=fixed)
		( inst name="presult_6" cell=pc3o01 place_status=fixed)
		( inst name="presult_5" cell=pc3o01 place_status=fixed)
		( inst name="presult_4" cell=pc3o01 place_status=fixed)
		( inst name="presult_3" cell=pc3o01 place_status=fixed)
		( inst name="presult_2" cell=pc3o01 place_status=fixed)
		( inst name="presult_1" cell=pc3o01 place_status=fixed)
		( inst name="presult_0" cell=pc3o01 place_status=fixed)
		( inst name="pcarry" cell=pc3o01 place_status=fixed)
)
(bottomleft
(inst name="CornerCell4" cell=pfrelr offset=0 orientation=R270 place_status=fixed )
)
(bottom
		( inst name="pzero" cell=pc3o01 place_status=fixed)
		( inst name="psign" cell=pc3o01 place_status=fixed)
		( inst name="poverflow" cell=pc3o01 place_status=fixed)
		( inst name="VDD" cell=pvdi place_status=fixed)
		( inst name="VDDO" cell=pvda place_status=fixed)
		( inst name="VSSO" cell=pv0a place_status=fixed)
		( inst name="VSS" cell=pv0i place_status=fixed)
		( inst name="pDUMMY_1" cell=pc3d01 place_status=fixed)
		( inst name="pDUMMY_2" cell=pc3d01 place_status=fixed)
		( inst name="pDUMMY_3" cell=pc3d01 place_status=fixed)
)
)
