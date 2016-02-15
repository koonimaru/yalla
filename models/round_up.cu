// Simulating rounding up.
#include <assert.h>
#include <cmath>
#include <sys/stat.h>

#include "../lib/inits.cuh"
#include "../lib/solvers.cuh"
#include "../lib/vtk.cuh"


const float R_MAX = 1;
const float R_MIN = 0.6;
const int N_CELLS = 100;
const float DELTA_T = 0.005;

__device__ __managed__ LatticeSolver<float3, N_CELLS> solver;
__device__ __managed__ int time_step;


__device__ float3 clipped_polynomial(float3 Xi, float3 Xj, int i, int j) {
    float3 dF = {0.0f, 0.0f, 0.0f};
    float3 r = {Xi.x - Xj.x, Xi.y - Xj.y, Xi.z - Xj.z};
    float dist = fminf(sqrtf(r.x*r.x + r.y*r.y + r.z*r.z), R_MAX);
    if (i != j) {
        int n = 2;
        float strength = 100;
        float F = strength*n*(R_MIN - dist)*powf(R_MAX - dist, n - 1)
            + strength*powf(R_MAX - dist, n);
        dF.x = r.x*F/dist;
        dF.y = r.y*F/dist;
        dF.z = r.z*F/dist;
    }
    assert(dF.x == dF.x); // For NaN f != f.
    return dF;
}

__device__ __managed__ nhoodint<float3> potential = clipped_polynomial;


// Smooth transition from step(x < 0) = 0 to step(x > 0) = 1 over dx
__device__ float step(float x) {
    float dx = 0.1;
    x = __saturatef((x + dx/2)/dx);
    return x*x*(3 - 2*x);
}

__global__ void squeeze_kernel(const __restrict__ float3* X, float3* dX) {
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    float time = time_step*DELTA_T;
    if (i < N_CELLS) {
        dX[i].z += 10*step(-2 - X[i].z); // Floor
        if ((time >= 0.1) && (time <= 0.5)) {
            dX[i].z -= 10*step(X[i].z - (2 - (time - 0.1)/0.3));
        }
    }
}

void squeeze_to_floor(const float3* __restrict__ X, float3* dX) {
    squeeze_kernel<<<(N_CELLS + 16 - 1)/16, 16>>>(X, dX);
    cudaDeviceSynchronize();
}


int main(int argc, char const *argv[]) {
    // Prepare initial state
    uniform_circle(N_CELLS, 0.733333, solver.X);
    // uniform_sphere(N_CELLS, 0.733333, solver.X);

    // Integrate cell positions
    VtkOutput output("round_up");
    for (time_step = 0; time_step*DELTA_T <= 1; time_step++) {
        output.write_positions(N_CELLS, solver.X);

        if (time_step*DELTA_T <= 1) {
            solver.step(DELTA_T, N_CELLS, potential, squeeze_to_floor);
        }
    }

    return 0;
}
