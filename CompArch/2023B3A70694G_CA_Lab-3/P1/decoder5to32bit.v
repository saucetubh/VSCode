/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/


module decoder_5to32(input[4:0] destReg, output wire[31:0] decOut);

    wire t, u, v, w, y;
    wire nott, notu, notv, notw, noty;

    and (t, destReg[0], destReg[0]);
    and (u, destReg[1], destReg[1]);
    and (v, destReg[2], destReg[2]);
    and (w, destReg[3], destReg[3]);
    and (y, destReg[4], destReg[4]);

    not (nott, t);
    not (notu, u);
    not (notv, v);
    not (notw, w);
    not (noty, y);

    and (decOut[0], nott, notu, notv, notw, noty);
    and (decOut[1], t, notu, notv, notw, noty);
    and (decOut[2], nott, u, notv, notw, noty);
    and (decOut[3], t, u, notv, notw, noty);
    and (decOut[4], nott, notu, v, notw, noty);
    and (decOut[5], t, notu, v, notw, noty);
    and (decOut[6], nott, u, v, notw, noty);
    and (decOut[7], t, u, v, notw, noty);
    and (decOut[8], nott, notu, notv, w, noty);
    and (decOut[9], t, notu, notv, w, noty);
    and (decOut[10], nott, u, notv, w, noty);
    and (decOut[11], t, u, notv, w, noty);
    and (decOut[12], nott, notu, v, w, noty);
    and (decOut[13], t, notu, v, w, noty);
    and (decOut[14], nott, u, v, w, noty);
    and (decOut[15], t, u, v, w, noty);
    and (decOut[16], nott, notu, notv, notw, y);
    and (decOut[17], t, notu, notv, notw, y);
    and (decOut[18], nott, u, notv, notw, y);
    and (decOut[19], t, u, notv, notw, y);
    and (decOut[20], nott, notu, v, notw, y);
    and (decOut[21], t, notu, v, notw, y);
    and (decOut[22], nott, u, v, notw, y);
    and (decOut[23], t, u, v, notw, y);
    and (decOut[24], nott, notu, notv, w, y);
    and (decOut[25], t, notu, notv, w, y);
    and (decOut[26], nott, u, notv, w, y);
    and (decOut[27], t, u, notv, w, y);
    and (decOut[28], nott, notu, v, w, y);
    and (decOut[29], t, notu, v, w, y);
    and (decOut[30], nott, u, v, w, y);
    and (decOut[31], t, u, v, w, y);



endmodule