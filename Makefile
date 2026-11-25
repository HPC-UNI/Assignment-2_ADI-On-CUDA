VER ?= ref
DATASET ?= mini
DUMP_ARRAYS ?=
NTHREADS ?= $(shell nproc)

CUDA_HOME ?= /usr/local/cuda
NVCC = $(CUDA_HOME)/bin/nvcc

# Flag di base e macro per PolyBench
COMMON_FLAGS = \
	-O2 \
	-Icommon/ \
	-D$(shell echo $(DATASET) | tr '[:lower:]' '[:upper:]')_DATASET \
	-DPOLYBENCH_TIME \
	-DPOLYBENCH_NTHREADS=$(NTHREADS)

ifneq ($(DUMP_ARRAYS),)
	COMMON_FLAGS += -DPOLYBENCH_DUMP_ARRAYS
endif

# Flag specifici per NVCC (passa -fopenmp al compilatore host gcc/g++)
NVCCFLAGS = $(COMMON_FLAGS) -Xcompiler -fopenmp -lineinfo
LDFLAGS = -lm -lcudart -lgomp

TARGET = adi_$(VER)

ALL_SRCS = $(shell find . -type f -name "adi_*.cu")
ALL_TARGETS = $(ALL_SRCS:.cu=)

.PHONY: build
build: $(TARGET)

.PHONY: run
run: $(TARGET)
	@echo "Running $<"
	@./$<

.PHONY: all
all: $(ALL_TARGETS)

# Regola pattern: compila adi_<VER>.cu e common/polybench.c insieme
%: %.cu common/polybench.c
	$(NVCC) $(NVCCFLAGS) -x cu -o $@ $^ $(LDFLAGS)

.PHONY: clean
clean:
	find . -type f -name "adi_*" -and -executable -delete  