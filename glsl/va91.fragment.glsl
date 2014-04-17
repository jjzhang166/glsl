// Carry the Torch: a #glslsandbox shader game by @emackey.
// Inspired by @Flexi23's http://glsl.heroku.com/91/3
// and of course http://glsl.heroku.com/92/0 and http://glsl.heroku.com/79/10

// Directions:
// Move your mouse to the yellow start post at the bottom-right.  Get the
// green flame and carry it slowly and safely to the purple goal post
// in the upper-right.  If the screen turns blue, you win!!

// For a better view, click "hide code" in the upper-left.
// To reset the game, resize the browser window.
// For challenge mode, turn off the yellow trails (see comment in code).

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec2 startPost = vec2(0.8, 0.2);
	vec2 goalPost = vec2(0.8, 0.8);

	float rnd1 = mod(fract(sin(dot(position + time, vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd2 = mod(fract(sin(dot(position+vec2(rnd1), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd3 = mod(fract(sin(dot(position+vec2(rnd2), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd4 = mod(fract(sin(dot(position+vec2(rnd3), vec2(14.9898,78.233))) * 43758.5453), 1.0);

	vec4 backColor0 = texture2D(backbuffer, position);
	vec4 backColor1 = texture2D(backbuffer, position + pixel*(vec2(rnd3, rnd4)-0.5)*2.);
	vec4 backColor2 = texture2D(backbuffer, position + pixel*(vec2(rnd4, rnd3)-0.5)*-2.);

	vec2 posMods = mod(position + 0.05, 0.1);
	vec2 posFloor = floor(position * 10.0 + 0.5);
	float mazeNumber = floor((time + 72.2) * 0.2) + 2.002;

	if (((posMods.x < 0.01) && (sin((0.02 * posFloor.x + posFloor.y) * mazeNumber * 4315.78) < 0.2)) ||
	    ((posMods.y < 0.01) && (cos((0.1 * posFloor.y + posFloor.x) * mazeNumber * 8318.42) < 0.5))) {
		// Place some walls around...
		gl_FragColor = vec4(0.4, 0.4, 0.4, 0.0);
	} else if (((backColor1.b > 0.39) && (backColor1.b < 0.41)) ||
		   ((backColor2.b > 0.39) && (backColor2.b < 0.41))) {
		// Hit a wall, no flame for you.
		gl_FragColor = vec4(0.);
	} else if (((backColor1.b > 0.5) && (backColor1.g > 0.45) && (backColor1.r < 0.8)) ||
	           ((backColor2.b > 0.5) && (backColor2.g > 0.45) && (backColor2.r < 0.8))) {
		// Winner!!
		float winColor = pow(max(backColor1.g, backColor2.g) * 0.999, 0.1);
		gl_FragColor = vec4(0., winColor * 0.5, winColor, 0.);
	} else if ((backColor0.b < 0.2) && (backColor0.g > 0.8) && (backColor0.r > 0.8)) {
		gl_FragColor = backColor0;
	} else {
		// Gameplay zone: carry the torch (or not!)
		float gammaG = (clamp(length(position-mouse)*42., 1., 1.5) - 1.0) * (2.0 * 9.9) + 0.1;
		float newColorG = pow(max(backColor1.g, backColor2.g) * 0.999, gammaG);
		float gammaR = (clamp(length(position-mouse)*82., 1., 1.5) - 1.0) * (2.0 * 9.9) + 0.1;
		float newColorR = pow(max(backColor1.r, backColor2.r) * 0.5, gammaR);

		//
		// CHALLENGE MODE: turn off trails by un-commenting this:
		//
		newColorR = 0.0;
		gl_FragColor = vec4(min(newColorR, newColorG), newColorG, 0., 0.);
	}

	gl_FragColor.rg += 3. - (clamp(length(position-startPost)*128., 2.0, 3.0));
	float goalColor = 3. - (clamp(length(position-goalPost)*128., 2.0, 3.0));
	gl_FragColor.b += goalColor;
	gl_FragColor.r += goalColor * 0.5;
	
	// To reset your game, resize the browser, or
	// un-comment and re-comment the following line.
	//gl_FragColor = vec4(0.);
}
