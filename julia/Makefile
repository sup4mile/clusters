#By default, runs model with pre-compiled julia environment if available
#Use <make nosysimage=true ...> to specifically avoid using a sysimage.

Force_NoSysimage = false
FLAGS =

run: | decide
	julia $(FLAGS) NLsolvemodel.jl
test: | decide
	julia $(FLAGS) NLsolvemodel_tester.jl
sysimage:
	#This must build the image entirely independently
	julia MakeSysimage.jl
decide:
ifndef nosysimage
ifneq (,$(wildcard ./SysimageEnvironments/NLsolveSysimage.so))
FLAGS += --sysimage "NLsolveSysimage.so"
	#echo "Sysimage NLsolveSysimage.so found, will be used"
else
	#echo "No Sysimage found, default Julia will be used"
endif
endif