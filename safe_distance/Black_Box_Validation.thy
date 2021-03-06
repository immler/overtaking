theory Black_Box_Validation
imports "./Black_Box_Safe_Distance"
begin

  
  
type_synonym 'a tuple8 = "'a*'a*'a*'a*'a*'a*'a*'a"
type_synonym val_single_trace = "(real tuple6) list"

type_synonym raw_single_trace = "(nat * real * nat * real * real * nat * real * real) list" 
type_synonym raw_traces = "raw_single_trace list"
type_synonym val_traces = "val_single_trace list"

fun interpret_single_trace_f :: "real tuple8 \<Rightarrow> real tuple6" where
"interpret_single_trace_f (_, distance, _, ve, ae, _, vo, ao) = (0, ve, ae, distance, vo, ao)"

text {* A single trace is defined by a set of raw data points where all of them have the same 
        ego vehicle ID. They also have the same other vehicle ID. *}

definition interpret_single_trace :: "raw_single_trace \<Rightarrow> val_single_trace" where
"interpret_single_trace = map interpret_single_trace_f"

definition interpret_raw_data :: "raw_traces \<Rightarrow> val_traces" where
"interpret_raw_data = map interpret_single_trace"


text {* interpret function for interfacing raw data (test vector) with the current validation
        framework *}

definition "precision = 80"

(* fun single_result :: "val_single_trace \<Rightarrow> bool" where
"single_result trc = check_bb_safe_dist'' precision trc"
 *)

fun numbering_result :: "bool list \<Rightarrow> (nat \<times> bool) list" where
"numbering_result res = zip [0..<(length res)] res"

fun filter_witness :: "bool list \<Rightarrow> nat list" where
"filter_witness res = map fst (filter (\<lambda>nres . snd nres = True) (numbering_result res))"

fun single_result_wit :: "val_single_trace \<Rightarrow> nat list" where
"single_result_wit trc = filter_witness (check_bb_safe_dist_wit'' precision trc)"

fun frame_id_wit_tail :: "nat list \<Rightarrow> raw_single_trace \<Rightarrow> nat list \<Rightarrow> nat list" where
"frame_id_wit_tail [] trc res = res" | 
"frame_id_wit_tail (n # ns) trc res = frame_id_wit_tail ns trc (res @ [fst (trc ! n)])"

fun frame_id_wit :: "nat list \<Rightarrow> raw_single_trace \<Rightarrow> nat list" where
"frame_id_wit ns trc = frame_id_wit_tail ns trc []"

(* may take long time to compute the result *)
(* export_code result in SML *)
(* value [code] result *)

(* may take long time to compute the result *)
(* export_code result_wit in SML *)
(* value [code] result_wit *)

(*
lemma "witness_frame = 
[[168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 234,
   235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 261, 262, 263,
   264, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281,
   282, 283, 284, 285, 286, 287, 288, 300, 301, 302, 303, 304, 305, 306, 307, 308,
   309, 310, 311, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332,
   333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348,
   349, 350, 351, 352, 353, 354, 355, 370, 371, 372, 373, 374, 375, 376, 377, 379,
   380, 381, 382, 383, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397,
   398, 399, 400, 406, 407, 408, 409, 413, 414, 415, 416, 417, 418, 419, 420, 421,
   422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437,
   460, 461, 462, 463, 464, 465, 478],
  [63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82,
   83, 106, 107, 123, 124, 125, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138,
   141, 142, 143, 144, 145, 146, 149, 150, 151, 152, 153, 154, 155, 156, 160, 161,
   169, 170, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 191,
   192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
   208, 209, 210, 211, 227, 228, 234, 235, 236, 239, 240, 241, 242, 243, 244, 245,
   246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261,
   262, 263, 264, 265, 266, 267, 268, 269, 270, 272, 273, 274, 275, 276, 277, 278,
   279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294,
   295, 296, 297, 298, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312,
   313, 314, 315, 316, 317, 318, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337,
   338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 356, 357,
   358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373,
   374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389,
   390, 391, 392, 393, 394, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411,
   412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427,
   428, 429, 430, 431, 432, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459],
  [207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222,
   223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238,
   239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254,
   255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 273,
   274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289,
   290, 291, 292, 293, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360,
   361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376,
   377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392,
   393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408,
   409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424,
   425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440,
   441, 442, 443, 444, 445, 446, 447, 448, 449],
  [77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 93, 94, 95, 96, 97, 98, 99, 100, 101,
   102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117,
   118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133,
   134, 135, 136, 137, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160,
   161, 162, 163, 164, 165, 166, 167, 168, 169, 188, 189, 190, 191, 192, 218, 219,
   220, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253,
   254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 303,
   304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319,
   320, 321, 322, 323, 327, 328, 329, 330, 331, 332, 333, 335, 336, 337, 338, 339,
   340, 341, 342, 343, 344, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375,
   376, 377, 378, 379, 380, 381, 382, 383, 385, 386, 387, 388, 389, 390, 391, 392,
   393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408,
   409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424,
   425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440,
   441, 442, 443, 444, 452, 453, 454, 455, 456, 461, 462, 463, 464, 465, 466, 467,
   468, 469, 470, 471, 472, 473, 474],
  [22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
   42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
   62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,
   82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101,
   102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117,
   118, 119, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183,
   184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199,
   200, 201, 202, 203, 204, 205, 206]]"
by eval
*)

(*
definition "test1 = check_bb_safe_dist'' 80
  (replicate 1000 (0, 18.1,(-2.22), 1.1, 22.3, (-3.09)))"

export_code test1 in SML

definition "test2 = check_bb_safe_dist'' 80
  (replicate 1 (0, 20.23, (-2.22), 1.2, 22.8, (-3.09)))"

 
value [code] test1 
lemma "test1 = True"
  by eval

value [code] test2
lemma "test2 = False"
  by eval
*)

end
