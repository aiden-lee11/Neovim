-- Abbreviations used in this article and the LuaSnip docs
local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

vim.keymap.set({ 'i', 's' }, '<A-n>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set({ 'i', 's' }, '<S-Enter>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

ls.add_snippets('tex', {
  s(
    'beg',
    fmt(
      [[
	\begin{<>}
        <>
	\end{<>}
	]],
      {
        i(1),
        i(0),
        rep(1),
      },
      { delimiters = '<>' }
    )
  ),

  s(
    'ite',
    fmt(
      [[
	\begin{itemize}
        \item <>
	\end{itemize}
	]],
      {
        i(0),
      },
      { delimiters = '<>' }
    )
  ),

  -- Snippet for making a 212 Problem Template
  s(
    'prob',
    fmt(
      [[
	\begin{problem}
        <>
        \end{problem}

        \begin{shaded}
        \begin{solution}
        <>
        \end{solution}
        \end{shaded}

        \pagebreak
	]],
      {
        i(1),
        i(2),
      },
      { delimiters = '<>' }
    )
  ),

  s('qed', {
    t '\\hfill $\\square$', -- Ensure the backslashes are properly escaped
  }),
  -- Auto Subscript Snippet (for a single subscript digit):
  s({ trig = '([%a])(%d)', regTrig = true, wordTrig = false }, {
    f(function(_, snip)
      -- Capture the letter
      return snip.captures[1]
    end),
    t '_', -- Insert subscript notation
    f(function(_, snip)
      -- Capture the digit
      return snip.captures[2]
    end),
  }),

  -- Auto Subscript Snippet (for two subscript digits):
  s({ trig = '([%a])(%d%d)', regTrig = true, wordTrig = false }, {
    f(function(_, snip)
      -- Capture the letter
      return snip.captures[1]
    end),
    t '_{', -- Start subscript with curly braces
    f(function(_, snip)
      -- Capture the two digits
      return snip.captures[2]
    end),
    t '}', -- Close curly braces for subscript
  }),

  -- Make mm expand to $ $ (inline math), but not in words like “comment”, “command”, etc…

  s(
    { trig = '([^%a])mm', wordTrig = false, regTrig = true },
    fmta('<>$<>$', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = '([^%a])bd', wordTrig = false, regTrig = true },
    fmta('<>\\textbf{<>}', {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Figures
  s(
    'fig',
    fmt(
      [[
        \begin{figure}[htbp]
        \centering
        \includegraphics[width=1\textwidth]{<>}
        \caption{<>}
        \end{figure}
        ]],
      {
        i(1),
        i(2),
      },
      { delimiters = '<>' }
    )
  ),

  s(
    'sfig',
    fmt(
      [[
\begin{figure}[ht!]
     \begin{center}
%
        \subfigure[<>]{%
            \label{fig:first}
            \includegraphics[width=0.5\textwidth]{<>}
        }%
        \subfigure[<>]{%
           \label{fig:second}
           \includegraphics[width=0.5\textwidth]{<>}
        }
    \end{center}
    \caption{%
            <>
     }%
   \label{fig:subfigures}
\end{figure}
        ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
      },
      { delimiters = '<>' }
    )
  ),

  -- General Earth Bullet Section
  s(
    'eb',
    fmt(
      [[
\indent \hspace{1em} \textbf{<>}
\begin{itemize}
  \item <>
\end{itemize}
        ]],
      {
        i(1),
        i(0),
      },
      { delimiters = '<>' }
    )
  ),

  s('ra', {
    t '$\\rightarrow$', -- Ensure the backslashes are properly escaped
  }),

  s(
    '212t',
    fmt(
      [[
\documentclass[12pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage[all]{xy}

\usepackage{amsmath,amsthm,amssymb,color,latexsym}
\usepackage{mathtools}
\usepackage{geometry}        
\geometry{letterpaper}    
\usepackage{graphicx}
\usepackage{tabto}
\usepackage{setspace}


\usepackage[noframe]{showframe}
\usepackage{framed}

% Sets up "environments" of formatted text.
\renewenvironment{shaded}{%
        \def\FrameCommand{\fboxsep=\FrameSep \colorbox{shadecolor}}%
\MakeFramed{\advance\hsize-\width \FrameRestore\FrameRestore}}%
{\endMakeFramed}
\definecolor{shadecolor}{gray}{0.90}

\newtheorem{problem}{Problem}

% Define XOR symbol as a custom command if you want to use \xor
\newcommand{\lxor}{\oplus} 

\newenvironment{solution}[1][\it{Solution:}]{\textbf{#1 } }


% Sets spacing for the document
\onehalfspacing

% All latex documents begin with a `\begin{document}`
\begin{document}
\begin{titlepage}
        \begin{center}
                \vspace*{9cm}

                \textbf{CS 212 Fall 2024}

                \vspace{0.5cm}
                Homework \#4

                \vfill

                \textbf{Aiden Lee}\\
                NetID yaz7336\\
                Collaborators: Bhuvan Madala, Nathan Stall\\             
                Due Date: <>

        \end{center}
\end{titlepage}

%\hrulefill
\pagebreak

\begin{problem}
  <>
\end{problem}

\begin{shaded}
        \begin{solution}
          <>
        \end{solution}
\end{shaded}

% Creates a new page
\pagebreak

\begin{problem}
        Feedback \\
        Please share approximately how many hours you spent working on this assignment. Report your estimate to the nearest hour. This will help us calibrate our assignments in the future. \\ \\
        If you have any additional feedback, we welcome that as well.

\end{problem}

\begin{shaded}
        \begin{solution}
                I spent approximately <> hours working on this assignment. 
        \end{solution}
\end{shaded}

\end{document}
      ]],

      {
        i(1),
        i(2),
        i(3),
        i(4),
      },
      { delimiters = '<>' }
    )
  ),

  s(
    '212p',
    fmt(
      [[
\begin{problem}
  <>
\end{problem}

\begin{shaded}
        \begin{solution}
          <>
        \end{solution}
\end{shaded}

% Creates a new page
\pagebreak
  ]],
      {
        i(1),
        i(2),
      },
      { delimiters = '<>' }
    )
  ),

  s('ps', {
    t '$\\mathcal{P}$', -- Ensure the backslashes are properly escaped
  }),
  s(
    'ilim',
    fmt(
      [[
    \[
    \lim_{{x \to \infty}} {}
    \]
    ]],
      {
        i(1),
      },
      { delimiters = '{}' }
    )
  ),
  s(
    'flim',
    fmt(
      [[
    \[
    \lim_{{x \to \infty}} \frac{{{}}}{{{}}}
    \]
    ]],
      {
        i(1),
        i(2),
      },
      { delimiters = '{}' }
    )
  ),
})
