#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// posted by Trisomie21


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float cuberoot( float x )
{
	if( x<0.0 ) return -pow(-x,1.0/3.0);
	return pow(x,1.0/3.0);
}

int solveCubic(in float a, in float b, in float c, out float r[3])
{
	float  p = b - a*a / 3.0;
	float  q = a * (2.0*a*a - 9.0*b) / 27.0 + c;
	float p3 = p*p*p;
	float  d = q*q + 4.0*p3 / 27.0;
	float offset = -a / 3.0;
	if(d >= 0.0) { // Single solution
		float z = sqrt(d);
		float u = (-q + z) / 2.0;
		float v = (-q - z) / 2.0;
		u = cuberoot(u);
		v = cuberoot(v);
		r[0] = offset + u + v;
		return 1;
	}
	float u = sqrt(-p / 3.0);
	float v = acos(-sqrt( -27.0 / p3) * q / 2.0) / 3.0;
	float m = cos(v), n = sin(v)*1.732050808;
	r[0] = offset + u * (m + m);
	r[1] = offset - u * (n + m);
	r[2] = offset + u * (n - m);
	return 3;
}


float DistanceToQBSpline(in vec2 P0, in vec2 P1, in vec2 P2, in vec2 p)
{
	float dis = 1e20;
	
	vec2  sb = (P1 - P0) * 2.0;
	vec2  sc = P0 - P1 * 2.0 + P2;
	vec2  sd = P1 - P0;
	float sA = 1.0 / dot(sc, sc);
	float sB = 3.0 * dot(sd, sc);
	float sC = 2.0 * dot(sd, sd);
	
	vec2  D = P0 - p;

	float a = sA;
	float b = sB;
	float c = sC + dot(D, sc);
	float d = dot(D, sd);

    	float res[3];
	int n = solveCubic(b*a, c*a, d*a, res);

	float t = clamp(res[0],0.0, 1.0);
	vec2 pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p));
	
    	if(n>1) {
	t = clamp(res[1],0.0, 1.0);
	pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p));
	    
	t = clamp(res[2],0.0, 1.0);
	pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p));	    
    	}

    	return dis;
}

void main( void ) {

	vec2 pos = gl_FragCoord.xy / resolution;
	pos *= vec2(2.0);
	pos -= vec2(1.0);
	vec2 p[3];
	
	p[0] = vec2(0.0); 
	p[1] = vec2(0.5+sin(time)*0.15, cos(time)*0.75);
	p[2] = vec2(0.5-sin(time)*0.5, -cos(time)*0.15);
	
	pos.x = abs(pos.x*pos.x);
	
	float d = DistanceToQBSpline(p[0], p[1], p[2], pos);
	
	float lineThickness = 0.95*(1.0-length(pos*0.1));
	float lineSoftness = 0.125;
	
	d =1.0-clamp((d - (lineThickness-1.0)) / lineSoftness, 0.0, 1.0);
	d*=1.5;
	gl_FragColor = vec4( d,d*0.6,d*0.2, 1.0 );

}