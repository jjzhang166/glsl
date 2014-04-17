#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;

void main( void ) {
	
	//Block Sampler - An illustrated adventure!
	
	//This shader just divides pixels into 4 regular intervals (as you might use for sampling blocks in compression) 
	//It could be extended to more dimensions for larger blocks.
	
	
	//Uncomment as you go! 
	
	vec2 uv		= gl_FragCoord.xy / resolution.xy; 	//Continuous linear 0-1 uv map(a plane with positive slope)
	gl_FragColor 	= vec4(uv, 0.0, 1.0 ) ;
	
	/*
	vec2 n		= vec2(32., 32.);			//Rotating color by magic numbers;
	vec2 rotuv	= uv * n;				//Multiply uv by n - the plane is now much steeper.						
	gl_FragColor 	= vec4(rotuv, 0.0, 1.0 ) ;		//It now contains the information of n across it's slope
								//as the transformation is unique at each point, n is mapped 1:1
	
	
	/*
	vec2 ints	= floor(rotuv);				//By flooring the values to the nearest int
	gl_FragColor 	= vec4(ints* 1./n, 0.0, 1.0 ) ;		//the plane is flattened into 32 distinct intervals (integers)
								//(1./n for illustrative purposes)
								//This destroys some information about n
	
	
	/*
	vec2 map = rotuv - ints;				//Lowering the steeply sloped plane (rotuv) by subtracting regular 
	gl_FragColor 	= vec4(map, 0.0, 0.0);			//intervals undoes the slope rotation while retaining the interval
								//information, thus a remapping of uv by n intervals 
	
	/*
	vec2 reduce = floor(map * 2.);				//Another rotation and floor splits the plane into 4 intervals
								//Suitable for your block sampling needs
	
	gl_FragColor 	= vec4(reduce, 0.0, 0.0);
	
	/*
	vec2 subDiv	= floor(fract(uv*n)*2.); 		//One line version.
	float cursor 	= step(.98, 1.-length(uv-mouse));
	gl_FragColor 	= vec4(subDiv, cursor, 0.0); 
	
	/**///- sphinx
	
}