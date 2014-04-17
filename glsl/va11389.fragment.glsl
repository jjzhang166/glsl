#ifdef GL_ES
precision mediump float;
#endif

void triangle(vec3 a, vec3 b, vec3 c, vec3 color)
{
	float a1 = (a.x - gl_FragCoord.x) * (b.y - a.y) - (b.x - a.x) * (a.y - gl_FragCoord.y);
        float a2 = (b.x - gl_FragCoord.x) * (c.y - b.y) - (c.x - b.x) * (b.y - gl_FragCoord.y);
        float a3 = (c.x - gl_FragCoord.x) * (a.y - c.y) - (a.x - c.x) * (c.y - gl_FragCoord.y);

	if ((a1 > 0. && a2 > 0. && a3 > 0.) || (a1 < 0. && a2 < 0. && a3 < 0.))
	{
		float A = a.y * (b.z - c.z) + b.y * (c.z - a.z) + c.y * (a.z - b.z);
                float B = a.z * (b.x - c.x) + b.z * (c.x - a.x) + c.z * (a.x - b.x);
                float C = a.x * (b.y - c.y) + b.z * (c.y - a.y) + c.x * (a.y - b.y);
                float D = - a.x * (b.y * c.z - c.y * b.z) + b.x * (c.y * a.z - a.y * c.z) + c.x * (a.y * b.z - b.y * a.z);
		if (C == 0.) C = 0.00001;
	float z = (- A * gl_FragCoord.x - B * gl_FragCoord.y - D) / C;
		if (gl_FragColor.a < z)
		{
			gl_FragColor.xyz = color;
			gl_FragColor.a = z;
		}
	}			
}
void main(){	
	gl_FragColor.a = -1e10;
	triangle(vec3(50.,40.,-250.), vec3(350.,150.,-500.), vec3(100.,100.,-100.), vec3(1.,1.,0.0)); // near
	triangle(vec3(10.,30.,-1000.), vec3(150.,0.,-2000.), vec3(250.,200.,-400.), vec3(0.,0.,.8)); // medium
	triangle(vec3(0.,200.,-4500.), vec3(250.,150.,-4100.), vec3(100.,100.,-4200.), vec3(1.,0.,0.)); // deep
}