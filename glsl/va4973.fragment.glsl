#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// posted by Trisomie21
//forked by ind

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





void main(void)
{
	vec2 position = gl_FragCoord.xy;
	vec2 p[3];
	
	float t = time;
	
	float sz = min(resolution.x, resolution.y);
	p[0] = vec2(sz*(.90-(sin(t*1.0)*.095)-max((sin(t*1.0)*.085),0.0)+max(-(sin(t*1.0)*.2),0.0)),sz*(.5-(sin(t*1.0)*0.1)));
	p[1] = vec2(sz*(.70+(sin(t*1.0))*(sign(sin(t*1.0)) > 0.0 ? .008 : .3)*sign(sin(t*1.0))),
		    sz*(.5+max((sin(t*1.0))*0.04, 0.008)));
	p[2] = vec2(sz*.55,sz*.52);
	
	float amp = (sin(t)*0.2+1.0)*1.1;
	vec2 balls = vec2(sz*.59,sz*.47);
	vec2 balls2 =vec2(sz*.51,sz*.47); 
	vec2 balls3 =vec2(sz*.53,sz*.60); 
	float d = min(min(min(DistanceToQBSpline(p[0], p[1], p[2], position)*amp,
			  DistanceToQBSpline(balls, balls, balls, position)*(0.7)*amp),
			  DistanceToQBSpline(balls2, balls2, balls2, position)*(0.7)*amp),
		          DistanceToQBSpline(balls3, balls3, balls3, position*vec2(1.0, 1.2))*0.52*amp)
		          ;
	
	float lineThickness = 15.0*sz/300.0;
	float lineSoftness = 0.004*sz;
	float outline = 0.004*sz;
	d = (d - (lineThickness-1.0)) / lineSoftness;
	if(outline>0.0) d = abs(d)-outline;

	
	// Curve Control point
	//vec2 dir = ((p[0]-p[1]));
	//d = min(d, (length(p[0]+(dir)*0.2/amp - position)-sz*0.01/amp));
	
	d = clamp(d, 0.0, 1.0);
	d = mix(0.8, 0.5, d);
	
	gl_FragColor = vec4(d,d,d, 1.0);
}