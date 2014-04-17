// bubblegum by Kabuto. based on code from @ahnqqq (raymarcher) and Ian McEwan, Ashima Arts (simplex noise)

# ifdef GL_ES
precision mediump float;
# endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Start simplex noise

	//
	// Description : Array and textureless GLSL 2D/3D/4D simplex
	// noise functions.
	// Author : Ian McEwan, Ashima Arts.
	// Maintainer : ijm
	// Lastmod : 20110822 (ijm)
	// License : Copyright (C) 2011 Ashima Arts. All rights reserved.
	// Distributed under the MIT License. See LICENSE file.
	// https://github.com/ashima/webgl-noise
	//
	// Modified by Kabuto to return the derivative as well
	//
	
	
	

void main()
{
	
	gl_FragColor = vec4( sqrt(10.8), 1. );
}

