
	c = cos(a); s = sin(a);
	p.y = c * q.y - s * q.z;
	p.z = s * q.y + c * q.z;
}

void rY(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.x = c * q.x + s * q.z;
	p.z = -s * q.x + c * q.z;
}

void rZ(inout vec3 p, float a) {
	float c,s;vec3 q=p;
	c = cos(a); s = sin(a);
	p.x = c * q.x - s * q.y;
	p.y = s * q.x + c * q.y;
}

float sdPlane( vec3 p, vec4 n )
{
  // n must be normalized
  return dot(p,n.xyz) + n.w;
}

float f(in vec3 p) {
	float dist = 10000.0;	// a huge big number
	float new;	// not? used when comparing new distance to the old one
	float radius, thickness;
	//float object = 0.0;	 // which object did we hit (0 = floor);
	
	//dist = sdPlane(p + vec3(0.0, 3.9, 0.0), normalize(vec4(0.1, 0.4, 0.0, 1.0)));

	
	
	// we substract this from p
	p-= vec3(0.0, 5.0, -35.0);
	rX(p, 0.2 * (sin(time*0.6)) - 0.3);
	rY(p, 0.2 * (sin(time*0.5)) );
	dist = p.y - 2.0;
	float floordist = dist;
	//rX(p, time);
	//p-= vec3(5.0, 0.0, 0.0);
	//rZ(p, time * 0.9);
	vec3 dir = vec3(0.0, 1.0, 0.0);
	
	float tt = time * 3.0;
	
	rX(p, abs(sin(beat*0.5*PI)) * 0.1 );
	
	object = 0.0;
	
	/*
	for (float u=0.0;u<4.0;u++) {
		float phase = tt + u*0.5;
		float fat = (abs(sin(phase + 0.1)) * 0.2) ;
		
		radius = 2.0 + fat ;
		thickness = 0.1 + radius/3.0 + 0.5*sin(phase)*sin(tt*6.0)*(0.1/(u+1.0));
		float spacing = 1.7;
		new = sdTorus(p + dir*u*spacing + vec3(0.0, -7.5 - abs(sin(phase)) * 2.0, 0.0), vec2(radius, thickness));
		if (new < dist) {
			object = 1.0;	
		}
		dist = min(dist, new);
	}
	*/
	vec3 pp = p + vec3(0.0, 2.3, 0.0); 
	pp.y += -abs(sin(p.x*0.2+1.5))*abs(sin(beat*1.0*PI))*1.0;
	float move = (1.0+pow(sin(beat*9.0),2.0))*0.5*0.2;
	float shake = sin(time*50.0)*0.2*move; // this should be a global
	
	if (floordist != dist) {
		object = 1.0;
	}
	
	float box = sdBox(pp + vec3(0.0, -10.0, -5.0), vec3(4.0, 6.0, 5.0));
	float ball = min(dist, sphere(pp + vec3(0.0, -8.5, -11.5 ), 3.0));
	float ball2 = min(dist, sphere(pp + vec3(0.0, -8.5, -7.5 + shake - move), 2.0));
	dist = min(dist, min(max(box, -ball), ball2));

	
	//dist = 2.0 + p.y + sin(p.z) * sin(p.x) ;
	return dist;	
}


// normal
vec3 g(vec3 p) {
	vec2 e = vec2(0.01, 0.0);
	return (vec3(f(p+e.xyy),f(p+e.yxy),f(p+e.yyx))-f(p))/e.x;
}
	
// tips from iq
vec3 mars(inout vec3 p, inout vec3 d, float stepsize, float limit) {
	vec3 start = p;
	float l, iterations;
	iterations = 1.0;
	
	for (float i=0.0;i<MAX_ITER;i++) {
		l = f(p);
		p+=d*l*stepsize;	
		
		
		if (l < (limit)/(l+1.0)) {
			iterations = i;
			break;	
		}
	}
	
	return vec3(l, iterations, length(start-p));
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float ao(in vec3 p, vec3 n) {
	float acc = 0.0;
	for (float i=0.0;i<5.0;i++) {
		//vec3 pp = p;
		vec3 new = normalize(n + 0.3*vec3(rand(p.xy),rand(p.xy),rand(p.xy)));
		//vec3 new = normalize(vec3(rand(p.xy),rand(p.xy),rand(p.xy)));
		for (float u=0.0;u<4.0;u++) {
			acc += f(p+u*new*1.1)*0.022;
		}
	}
	
	return acc;	
		
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	// scene
	// sun light direction
	vec3 sun = normalize(vec3(-0.5, -0.7, -0.2));
	
	beat = time/(60.0/124.);
	
	//camera

	// position
	vec3 p = vec3(position.x - 0.5, (position.y - 0.5) * SCREEN_RATIO, -1.0);
	// direction
	vec3 d = normalize(p);
	
	float shade = 0.1;
	object = 0.0; 	// we assume the floor	
	
	//p += vec3(sin(time), 8.0, sin(time * 2.0) * 10.0 );
	p += vec3(0.0, 13.0, 0.0);
	vec3 col = vec3(0.1);	// background color
	
	// raymarching function
	// mars(vec3 position, vec3 direction, float stepsize, float limit
	
	vec3 dist = mars(p , d, 1.00, EPSILON);
	float realobj = object;
	if (dist.x < EPSILON) {
		// p.z pitäisi olla etäisyys
		
		vec3 n = g(p);
		float lighty = dot(n, vec3(0.5, 1.0, 0.5));
		shade = (1.0 + lighty) * 0.5 + 0.1;	
		shade += p.z * 0.009;
		shade += dist.y * 0.1;
		
		shade += realobj*5.0;
		
		// get the dot out of the surface
		p += n * EPSILON * 1.1;
		
		//shadows
		//float shadowratio = shadow(p, n, sun);
		float shadowratio = 1.0;
		//float o = 0.0;
		
		/*
		for (float o=0.0;o<90.0;o++) {
			float l = f(p);
			//p = p -sun*l*1.0;
			p = p -sun*1.0;
			shadowratio = shadowratio * 5.0;
			
			if (l < 1.0) {
				break;
				}
		
		}
		*/
		
		shadowratio = ao(p, n);
		
		
		//} while (o < 50.0);
		
		float red = object * lighty*0.5;
		float glass = pow(lighty * 0.8, 9.0) * object;
		col = vec3(shade + red + glass, shade - red*0.25 + glass, shade - red*0.25 + glass);
		col *= shadowratio;
	}
	
	
	
	
	gl_FragColor = vec4( col, 1.0 );

}