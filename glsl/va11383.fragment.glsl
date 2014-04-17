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
	float A = ( b.y - a.y ) * ( c.z - a.z ) - ( b.z - a.z ) * ( c.y - a.y );
		float B = ( b.z - a.z ) * ( c.x - a.x ) - ( b.x - a.x ) * ( c.z - a.z );
		float C = ( b.x - a.x ) * ( c.y - a.y ) - ( b.y - a.y ) * ( c.x - a.x );
		float D = - ( A * a.x + B * a.y + C * a.z );
		
		if ( abs ( C ) < 0.0001 ) C = 0.0001;
		float z = - ( A * gl_FragCoord.x + B * gl_FragCoord.y + D ) / C;
		if (gl_FragColor.a < z)
		{
			gl_FragColor.xyz = color;
			gl_FragColor.a = z;
		}
	}			
}
void main(){	
	gl_FragColor.a = -10000000.;
	triangle(vec3(50.,40.,-250.), vec3(350.,150.,-500.), vec3(100.,100.,-100.), vec3(1.,1.,0.0)); 
	triangle(vec3(10.,30.,-1.), vec3(150.,0.,-2.), vec3(250.,200.,-4.), vec3(0.,0.,.8));
	triangle(vec3(0.,200.,-4500.), vec3(250.,150.,-4100.), vec3(100.,50.,-4200.), vec3(1.,0.,0.)); 
}