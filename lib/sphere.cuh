// Distribute first N_CELLS in X[] uniformly random in sphere
template<typename Positions> void uniform_sphere(int N_CELLS, float mean_distance,
    Positions X[]) {
    float r_max = pow(N_CELLS/0.75, 1./3)*mean_distance/2; // Sphere packing
    for (int i = 0; i < N_CELLS; i++) {
        float r = r_max*pow(rand()/(RAND_MAX + 1.), 1./3);
        float theta = rand()/(RAND_MAX + 1.)*2*M_PI;
        float phi = acos(2.*rand()/(RAND_MAX + 1.) - 1);
        X[i].x = r*sin(theta)*sin(phi);
        X[i].y = r*cos(theta)*sin(phi);
        X[i].z = r*cos(phi);
    }
}
