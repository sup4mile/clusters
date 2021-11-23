#By default, runs model with pre-compiled julia environment if available
#Use <make nosysimage=true ...> to specifically avoid using a sysimage.

Force_NoSysimage = false
FLAGS =

run: | decide
	@echo "Running now!"
	julia$(FLAGS) NLsolvemodel.jl
test: | decide
	julia$(FLAGS) NLsolvemodel_tester.jl
sysimage:
	#This must build the image entirely independently
	julia MakeSysimage.jl
decide:
ifndef nosysimage
$(info Looking for available Sysimage...)
ifneq (,$(wildcard ./Sysimages/NLsolveSysimage.so))
$(info Sysimage NLsolveSysimage.so found)
FLAGS += --sysimage "./Sysimages/NLsolveSysimage.so"
else
$(info No Sysimage found, default Julia will be used)
endif
else
$(info <<nosysimage=true detected. Will not use available sysimages.>>)
endif