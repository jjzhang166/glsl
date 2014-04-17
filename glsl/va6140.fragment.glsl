#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//what is this i dont even?

float ang(vec2 v0, vec2 v1) {
	vec2 v01 = normalize(v0);
	vec2 v11 = normalize(v1);
	return acos(dot(v01, v11)); // (length(v0) * length(v1)));
}

// use this to draw the vectors, by finding points on/close to line and change thier color.
float minimum_distance(vec2 v, vec2 w, vec2 p) {
  	// Return minimum distance between line segment vw and point p
  	float l2 = (v.x - w.x)*(v.x - w.x) + (v.y - w.y)*(v.y - w.y); //length_squared(v, w);  // i.e. |w-v|^2 -  avoid a sqrt
	
  	if (l2 == 0.0) {
		return distance(p, v);   // v == w case
	}
	
	// Consider the line extending the segment, parameterized as v + t (w - v).
  	// We find projection of point p onto the line. 
  	// It falls where t = [(p-v) . (w-v)] / |w-v|^2
  	float t = dot(p - v, w - v) / l2;
	
  	if(t < 0.0) {
		// Beyond the 'v' end of the segment
		return distance(p, v);
	} else if (t > 1.0) {
		return distance(p, w);  // Beyond the 'w' end of the segment
	}
	
  	vec2 projection = v + t * (w - v);  // Projection falls on the segment
  	
	return distance(p, projection);
}


void main( void ) {
	
	
	vec2 radius = vec2(50.0, 50.0);
	vec2 size = resolution;
	vec2 destPos = mouse*resolution;
	vec3 lColor = vec3(0.9, 0.9, 0.9);
	//vec2 srcPos = resolution/2.0;
	vec2 srcPos = vec2(0.0, 1.0);
	
	//vec2 pos = gl_FragCoord.xy*size.xy;
	vec2 pos = gl_FragCoord.xy;
	//vec2 pos = (( gl_FragCoord.xy / resolution.xy ) - vec2(0.5)) / vec2(resolution.y/resolution.x,1.0);
	//vec2 pos = gl_FragCoord.xy / resolution.xy;
	
	float alphaMix = 0.0;
	
	vec3 color = lColor;
	
	//pos -= destPos;
	
	
	vec2 v0 = vec2(destPos - srcPos);
	
	vec2 v2 = vec2(pos - srcPos);
	
	
	// first calculate angle between v0 and v1, for use to calculate v1
	//float dist = length(srcPos*resolution - destPos);
	float dist = length(v0);
	float angle = atan(radius.x / dist);
	
	float hypotLen = sqrt(dist*dist + radius.x*radius.x);
	
	//vec2 v1 = vec2(hypotLen * cos(angle), hypotLen * sin(angle));
	
	float cosAng = cos(angle);
	float sinAng = sin(angle);
	vec2 v1 = vec2(v0.x * cosAng - v0.y * sinAng, v0.x * sinAng + v0.y * cosAng);
	//x' = cos(a) * x - sin(a) * y
	//y' = sin(a) * x + cos(a) * y
	
	
	//x = len1 * (float) Math.cos(theta);
        //y = len1 * (float) Math.sin(theta);
	
	
	// set v0 perpendicular clockwise to obtain first element in calculating v1
	vec2 v1element = vec2(-v0.x, v0.y);
	// set length of v1element to the length of radius
	float v1eLen = radius.y / length(v1element);
	v1element.x *= v1eLen;
	v1element.y *= v1eLen;
	
	//vec2 v1 = vec2((v0 + v1element) - srcPos);
	
	
	// angle between vectors
	/*
	float dot = v1.dot(v2);
	dot /= v1.length()*v2.length();
	return (float)Math.acos(dot);
	*/
	
	float angleV0V1 = ang(v0, v1);
	float angleV0V2 = ang(v0, v2);
	
	vec2 shiftedPos = vec2(pos - destPos);
	
	float len = shiftedPos.x*shiftedPos.x + shiftedPos.y*shiftedPos.y;
	float rLen = radius.x*radius.x;
	
	if(minimum_distance(srcPos, v0, pos) < 1.0) {
		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
	} else if(minimum_distance(srcPos, v1, pos) < 1.0) {
		gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
	}
	//else if(minimum_distance(srcPos, v2, pos) < 1.0) {
	//	gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
	//}
	else if(len < rLen) {
		gl_FragColor = vec4(1.0, 1.0, 0.0, 1.0);
	} else if(angleV0V1 > angleV0V2) {
		gl_FragColor = vec4(color, 1.0);
	} else {
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);	
	}
	
	
	
	
	/*
		// the cone (the barbarian)
		float dist = distance(destPos, vec2(srcPos*size));
		//float dist = destPos.x - (srcPos.x*size.x);
		
		float thetaZero = atan(radius.y / dist) * 2.0;
		float thetaOne = thetaZero - 0.2;
		
		float cosOuterCone = cos(thetaZero);
		float cosInnerCone = cos(thetaOne);
		
		vec3 delta = normalize(vec3(gl_FragCoord.xy, 0.0) - vec3(srcPos, 0.0));
		
		float angle = degrees(atan(mouse.y*size.y-srcPos.x, mouse.x*size.x-srcPos.y));
		float zr = radians(angle);
		float yr = 0.0;
		vec3 dir = vec3(cos(zr), sin(zr), 0.0);
		vec3 spotDir = normalize(dir);
		
  		float cosDirection = dot(delta, spotDir);
		
		float d = distance(gl_FragCoord.xy, srcPos);
		float shadow = 1.0 / (0.5 + (10.0*d) + (100.0*d*d));
		
		color *= smoothstep(cosOuterCone, cosInnerCone, cosDirection) * shadow;
		
		
		alphaMix = 1.0;
		//vec4 color = vec4(smoothstep(cosInnerCone, cosOuterCone, cosDirection) * shadow * lColor);
		//gl_FragColor = color;
		
		
	color *= alphaMix;
	
	//gl_FragColor = vec4(alphaMix, alphaMix, alphaMix, 1.0);
	gl_FragColor = vec4(color, 1.0);
	
	*/
}
