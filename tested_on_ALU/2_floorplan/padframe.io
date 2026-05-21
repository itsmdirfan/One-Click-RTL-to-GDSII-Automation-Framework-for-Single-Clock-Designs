(globals
version = 3
io_order = clockwise
space = 20 #Spacing between 2 IO pads
total_edge = 9
)

(iopad
(topleft
(inst name="CornerCell1" cell=pfrelr offset=0 orientation=R180 place_status=fixed )
)
(left
		( inst name="pclk" cell=pc3d01 place_status=fixed)
		( inst name="pcin" cell=pc3d01 place_status=fixed)
		( inst name="pa_7" cell=pc3d01 place_status=fixed)
		( inst name="pa_6" cell=pc3d01 place_status=fixed)
		( inst name="pa_5" cell=pc3d01 place_status=fixed)
		( inst name="pa_4" cell=pc3d01 place_status=fixed)
		( inst name="pa_3" cell=pc3d01 place_status=fixed)
		( inst name="pa_2" cell=pc3d01 place_status=fixed)
		( inst name="pa_1" cell=pc3d01 place_status=fixed)
)
(topright
(inst name="CornerCell2" cell=pfrelr offset=0 orientation=R90 place_status=fixed )
)
( top
		( inst name="pa_0" cell=pc3d01 place_status=fixed)
		( inst name="pb_7" cell=pc3d01 place_status=fixed)
		( inst name="pb_6" cell=pc3d01 place_status=fixed)
		( inst name="pb_5" cell=pc3d01 place_status=fixed)
		( inst name="pb_4" cell=pc3d01 place_status=fixed)
		( inst name="pb_3" cell=pc3d01 place_status=fixed)
		( inst name="pb_2" cell=pc3d01 place_status=fixed)
		( inst name="pb_1" cell=pc3d01 place_status=fixed)
		( inst name="pb_0" cell=pc3d01 place_status=fixed)
)
(bottomright
(inst name="CornerCell3" cell=pfrelr offset=0 orientation=R0 place_status=fixed )
)
( right
		( inst name="popcode_2" cell=pc3d01 place_status=fixed)
		( inst name="popcode_1" cell=pc3d01 place_status=fixed)
		( inst name="popcode_0" cell=pc3d01 place_status=fixed)
		( inst name="presult_7" cell=pc3o01 place_status=fixed)
		( inst name="presult_6" cell=pc3o01 place_status=fixed)
		( inst name="presult_5" cell=pc3o01 place_status=fixed)
		( inst name="presult_4" cell=pc3o01 place_status=fixed)
		( inst name="presult_3" cell=pc3o01 place_status=fixed)
		( inst name="presult_2" cell=pc3o01 place_status=fixed)
)
(bottomleft
(inst name="CornerCell4" cell=pfrelr offset=0 orientation=R270 place_status=fixed )
)
(bottom
		( inst name="presult_1" cell=pc3o01 place_status=fixed)
		( inst name="presult_0" cell=pc3o01 place_status=fixed)
		( inst name="pcout" cell=pc3o01 place_status=fixed)
		( inst name="pzero" cell=pc3o01 place_status=fixed)
		( inst name="VDD" cell=pvdi place_status=fixed)
		( inst name="VDDO" cell=pvda place_status=fixed)
		( inst name="VSSO" cell=pv0a place_status=fixed)
		( inst name="VSS" cell=pv0i place_status=fixed)
		( inst name="pDUMMY_1" cell=pc3d01 place_status=fixed)
)
)
